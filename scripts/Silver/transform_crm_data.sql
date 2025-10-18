USE DWH;

EXEC bronze.bronze_load_table_data; 
-- Clean data and insert it into the Silver layer

-- CRM: cust_info table
INSERT INTO silver.crm_cust_info (
    cust_id, cust_key, cust_firstname, cust_lastname, cust_gender, cust_marital_status, cust_create_date
)
    -- 1) Check for unwanted spaces (TRIM function)
    SELECT 
        cust_id, 
        cust_key, 
        TRIM(cust_firstname) AS cust_firstname, 
        TRIM(cust_lastname) AS cust_lastname, 
        -- 2) Clarify abbreviated values with CASE statements (e.g., M = Male, Null = N/A, etc.)
        CASE 
            WHEN UPPER(TRIM(cust_gender)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cust_gender)) = 'M' THEN 'Male'
            ELSE 'N/A'
        END AS cust_gender,
        CASE 
            WHEN UPPER(TRIM(cust_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cust_marital_status)) = 'S' THEN 'Single'
            ELSE 'N/A'
        END AS cust_marital_status,
        cust_create_date
    FROM (
        -- 3) Make sure that there are no duplicate customer IDs
        SELECT *, 
            ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_create_date DESC) AS recent_duplicate
        FROM bronze.crm_cust_info
        WHERE cust_id IS NOT NULL
    ) duplicate_checker
    WHERE recent_duplicate = 1
GO

-- CRM: product info table
INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_name, prd_cost, prd_line, prd_start_dt, prd_end_dt)
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_name,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,
    prd_start_dt,
    CAST(DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info
GO

-- CRM: Sales Details
INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    CASE WHEN LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(sls_order_dt AS DATE)
    END AS sls_order_dt,
    CASE WHEN LEN(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(sls_ship_dt AS DATE)
    END AS sls_ship_dt,
    CASE WHEN LEN(sls_due_dt) != 8 THEN NULL
        ELSE CAST(sls_due_dt AS DATE)
    END AS sls_due_dt,

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
GO

select * from silver.crm_sales_details
