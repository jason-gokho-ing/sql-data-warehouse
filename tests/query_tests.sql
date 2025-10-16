USE DWH;
GO



    -- Query that checks to see if there are any duplicate Customer IDs 
    SELECT cust_id, COUNT(*) AS [ID Count] 
        FROM silver.crm_cust_info
        GROUP BY cust_id
        HAVING COUNT(*) > 1 OR cust_id IS NULL

SELECT * FROM bronze.crm_sales_details

SELECT * FROM bronze.erp_prd_cat

-- Used to check any prd_id's missing in the ERP Product Category Table

SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_name, 
    prd_cost, 
    prd_line, 
    prd_start_dt, 
    prd_end_dt 
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') NOT IN (
    SELECT DISTINCT id FROM bronze.erp_prd_cat
)


-- showing rows where the prd_key does not match the sls_prd_key in the crm_sales_details table
-- Query produces products that do not have any orders attached to them
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id, -- Extract category ID
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Extract product key
    prd_name, 
    prd_cost, 
    prd_line, 
    prd_start_dt, 
    prd_end_dt 
FROM bronze.crm_prd_info

WHERE TRIM(SUBSTRING(prd_key, 7, LEN(prd_key))) NOT IN (
    SELECT DISTINCT TRIM(sls_prd_key) FROM bronze.crm_sales_details
);


-- Check for unwanted spaces
SELECT * FROM bronze.crm_prd_info
WHERE prd_name != TRIM(prd_name);


-- Check for negative numbers of NULLs
SELECT * FROM bronze.crm_prd_info
WHERE prd_cost <= 0 OR prd_cost IS NULL;

-- Use LEAD() function to find gaps in product date ranges
SELECT 
    prd_key, prd_name, prd_start_dt, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC) - 1 AS prd_end_dt
    FROM  bronze.crm_prd_info


-- Check for Invalid Order Dates
-- The product start date cannot be greater than the product end date
-- Expectation: No Results
SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT * FROM  silver.crm_prd_info;


-- Expectation: No Results
SELECT 
    sls_prd_key 
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);


SELECT prd_key FROM silver.crm_prd_info;

-- Check for Invalid Order Dates < Shipping Date & Due Date


SELECT * FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
OR sls_order_dt > sls_due_dt;

SELECT * FROM bronze.crm_sales_details


-- Check Data Consistency: Between Sales, Quantity, and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero, or negative
SELECT *
FROM (
        SELECT DISTINCT
        CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE WHEN sls_price IS NULL OR sls_price <= 0 
            THEN sls_sales / COALESCE(sls_quantity,0)
            ELSE sls_price 
        END AS sls_price

    FROM bronze.crm_sales_details
) t
WHERE sls_sales ! = (sls_quantity * sls_price)
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price
