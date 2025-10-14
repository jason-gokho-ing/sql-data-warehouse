USE DWH;
GO

EXEC bronze.bronze_load_table_data; 

    -- Query that checks to see if there are any duplicate Customer IDs 
    SELECT cst_id, COUNT(*) AS [ID Count] 
        FROM silver.crm_cust_info
        GROUP BY cst_id
        HAVING COUNT(*) > 1 OR cst_id IS NULL

SELECT * FROM bronze.crm_sales_details

SELECT * FROM bronze.erp_prd_cat

-- Used to check any prd_id's missing in the ERP Product Category Table

SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_nm, 
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
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_nm, 
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
WHERE prd_nm != TRIM(prd_nm);


-- Check for negative numbers of NULLs
SELECT * FROM bronze.crm_prd_info
WHERE prd_cost <= 0 OR prd_cost IS NULL;

-- Check for Invalid Order Dates
-- The product start date cannot be greater than the product end date
SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt