USE DWH;
GO


-- Ensure customer ID and customer key are matching between CRM and ERP
-- Expectation: No Results
SELECT cust_id 
FROM silver.erp_cust_info
WHERE cust_id
 NOT IN (SELECT DISTINCT cust_key FROM silver.crm_cust_info);

SELECT DISTINCT gender
    FROM silver.erp_cust_info;

SELECT birthday
    FROM silver.erp_cust_info
    WHERE birthday > GETDATE()

 -- silver.erp_locations
SELECT cust_id 
FROM silver.erp_locations
WHERE cust_id
NOT IN (SELECT DISTINCT cust_key FROM silver.crm_cust_info)

-- Data Standardization & Consistency. Make sure countries are accurate
SELECT DISTINCT country FROM silver.erp_locations

-- Ensure prd_id are all matching with the cat_id in the CRM Product Info Table
SELECT prd_id 
FROM silver.erp_prd_cat
WHERE prd_id
 NOT IN (SELECT DISTINCT cat_id FROM silver.crm_prd_info);




