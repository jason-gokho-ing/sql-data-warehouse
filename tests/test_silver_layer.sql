-- This SQL script contains data quality checks for the Silver Layer tables in the Data Warehouse
-- Reformatted and organized with section headers and spacing for readability
USE DWH;
GO

-- ================================================================
-- SECTION: Customer ID checks (duplicates / NULLs)
-- ================================================================

-- Query that checks to see if there are any duplicate Customer IDs 
SELECT cust_id, cust_create_date, recent_duplicate
    FROM (
        SELECT cust_id, cust_create_date,
            ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_create_date DESC) AS recent_duplicate
            FROM silver.crm_cust_info
            WHERE cust_id IS NOT NULL
        ) duplicate_checker
    WHERE recent_duplicate != 1;

-- Find rows where Customer ID is NULL
SELECT
    cust_id,
    COUNT(*) AS [ID Count]
FROM silver.crm_cust_info
WHERE cust_id IS NULL
GROUP BY cust_id;


-- ================================================================
-- SECTION: Product category / product-key checks
-- ================================================================
-- Used to compare cat_id in CRM Product Category Table to prd_id in ERP Table
SELECT DISTINCT *
FROM silver.crm_prd_info
WHERE cat_id NOT IN (
    SELECT DISTINCT prd_id
    FROM silver.erp_prd_cat
);


-- showing rows where the prd_key does not match the prd_key in the crm_sales_details table
-- Query produces products that do not have any orders attached to them
SELECT
    prd_key -- Extract product key
FROM silver.crm_prd_info
WHERE prd_key NOT IN (
    SELECT DISTINCT prd_key
    FROM silver.crm_sales_details
);


-- ================================================================
-- SECTION: Product data quality (names, costs, date ranges)
-- ================================================================
-- Check for unwanted spaces
SELECT *
FROM silver.crm_prd_info
WHERE prd_name != TRIM(prd_name);


-- Check for negative or NULL product costs
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost <= 0
   OR prd_cost IS NULL;


-- Use LEAD() function to find gaps in product date ranges
SELECT 
    prd_key,
    prd_name,
    prd_start_dt,
    DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS prd_end_dt
FROM silver.crm_prd_info;


-- Check for Invalid Order Dates
-- The product start date cannot be greater than the product end date
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ================================================================
-- SECTION: Cross-layer product references
-- ================================================================
-- Expectation: No Results
SELECT 
    sls_prd_key 
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);


-- ================================================================
-- SECTION: Order / Shipping / Due date checks
-- ================================================================
-- Check for Invalid Order Dates < Shipping Date & Due Date
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


-- ================================================================
-- SECTION: Sales consistency (sales = quantity * price)
-- ================================================================
-- Check Data Consistency: Between Sales, Quantity, and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero, or negative
SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;


-- ================================================================
-- SECTION: Cross-system customer checks (ERP vs CRM)
-- ================================================================
-- Ensure customer ID and customer key are matching between CRM and ERP
-- Expectation: No Results
SELECT
    cust_id
FROM silver.erp_cust_info
WHERE cust_id NOT IN (SELECT DISTINCT cust_key FROM silver.crm_cust_info);


-- Misc checks on ERP customer data
SELECT DISTINCT gender
FROM silver.erp_cust_info;

SELECT birthday
FROM silver.erp_cust_info
WHERE birthday > GETDATE();


-- ================================================================
-- SECTION: ERP locations checks
-- ================================================================
-- silver.erp_locations
SELECT
    cust_id
FROM silver.erp_locations
WHERE cust_id NOT IN (SELECT DISTINCT cust_key FROM silver.crm_cust_info);


-- Data Standardization & Consistency. Make sure countries are accurate
SELECT DISTINCT country
FROM silver.erp_locations;


-- ================================================================
-- SECTION: ERP product categories vs CRM product keys
-- ================================================================
-- Ensure prd_id are all matching with the cat_id in the CRM Product Info Table
SELECT
    prd_id
FROM silver.erp_prd_cat
WHERE prd_id NOT IN (
    SELECT DISTINCT REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id
    FROM silver.crm_prd_info
);
