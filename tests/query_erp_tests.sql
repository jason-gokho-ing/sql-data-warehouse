USE DWH;
GO

-- bronze.erp_cust_info
SELECT cust_id AS old_cust_id,
CASE WHEN cust_id LIKE 'NAS%' 
    THEN SUBSTRING(cust_id, 4, LEN(cust_id)) 
    ELSE cust_id 
END AS cust_id, 
birthday, gender 
FROM bronze.erp_cust_info

WHERE 
CASE WHEN cust_id LIKE 'NAS%' 
    THEN SUBSTRING(cust_id, 4, LEN(cust_id)) 
    ELSE cust_id 
END 
 NOT IN (SELECT DISTINCT cust_key FROM silver.crm_cust_info);


-- bronze.erp_locations
SELECT (REPLACE(cust_id,'-','')) AS cust_id, country 
FROM bronze.erp_locations
WHERE (REPLACE(cust_id,'-',''))
NOT IN (SELECT DISTINCT cust_key FROM silver.crm_cust_info)


SELECT cust_key FROM silver.crm_cust_info;