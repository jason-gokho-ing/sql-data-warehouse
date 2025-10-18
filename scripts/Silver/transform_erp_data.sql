USE DWH;

EXEC bronze.bronze_load_table_data; 
-- Clean data and insert it into the Silver layer
GO

-- bronze.erp_cust_info
INSERT INTO silver.erp_cust_info (cust_id, birthday, gender)
SELECT 
    CASE WHEN cust_id LIKE 'NAS%' 
        THEN SUBSTRING(cust_id, 4, LEN(cust_id)) 
        ELSE cust_id 
    END AS cust_id, 
    birthday, gender 
FROM bronze.erp_cust_info;

-- bronze.erp_locations
INSERT INTO silver.erp_locations (cust_id, country)
SELECT 
    (REPLACE(cust_id,'-','')) AS cust_id,
    country 
FROM bronze.erp_locations;

-- bronze.erp_prd_cat
INSERT INTO silver.erp_prd_cat (prd_id, cat, subcat, maintenance)
SELECT prd_id, 
    cat, 
    subcat, 
    maintenance 
FROM bronze.erp_prd_cat;

select * from silver.erp_prd_cat;

