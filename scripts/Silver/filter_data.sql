
USE DWH;

SELECT * FROM bronze.crm_cust_info;
GO

SELECT * FROM silver.crm_cust_info;
GO

-- Clean data and insert it into the Silver layer

INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_gender, cst_marital_status, cst_create_date)
    -- 1) Check for unwanted spaces (TRIM function)
    SELECT 
        cst_id, 
        cst_key, 
        TRIM(cst_firstname) AS cst_firstname, 
        TRIM(cst_lastname) AS cst_lastname, 
        -- 2) Clarify abbreviated values with CASE statements (e.g., M = Male, Null = N/A, etc.)
        CASE 
            WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
            ELSE 'N/A'
        END AS cst_gender,
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            ELSE 'N/A'
        END AS cst_marital_status,
        cst_create_date
    FROM (
        -- 3) Make sure that there are no duplicate customer IDs
        SELECT *, 
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS recent_duplicate
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) duplicate_checker
    WHERE recent_duplicate = 1 -- Selects the most recent record per customer
    GO


SELECT * FROM bronze.crm_prd_info;
GO



SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_nm, 
    COALESCE(prd_cost,0) AS prd_cost,
            CASE UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'N/A'
        END AS prd_line,  
    prd_start_dt, 
    prd_end_dt 
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') NOT IN (
    SELECT DISTINCT id FROM bronze.erp_prd_cat
)


