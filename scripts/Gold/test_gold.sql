
-- test to see if JOIN created duplicate values
SELECT cust_id, COUNT(*)
FROM (
SELECT
       ci.cust_id, 
       ci.cust_key, 
       ci.cust_firstname, 
       ci.cust_lastname, 
       ci.cust_gender, 
       ci.cust_marital_status, 
       ci.cust_create_date,
       loc.country,
       ei.birthday,
       ei.gender,
       ci.dwh_create_date
FROM silver.crm_cust_info ci
       LEFT JOIN silver.erp_cust_info ei
       ON ci.cust_key = ei.cust_key
       LEFT JOIN silver.erp_locations loc
       ON ci.cust_key = loc.cust_key
) t
GROUP BY cust_id
HAVING COUNT(*) > 1;

-- Ensure that the gender columns match between tables

SELECT DISTINCT
       ci.cust_gender,
       ei.gender,
-- used to update new information on customers' gender using the information from the CRM Customer Information table 
-- as the master table
       CASE 
            WHEN ci.cust_gender != 'N/A' THEN ci.cust_gender 
            ELSE COALESCE(ci.cust_gender, 'N/A')  
        END AS updated_gender
FROM silver.crm_cust_info ci
       LEFT JOIN silver.erp_cust_info ei
       ON ci.cust_key = ei.cust_key
       WHERE ci.cust_gender != cust_gender


-- Ensures that prd_key is unique
SELECT prd_key, COUNT(*) FROM (

SELECT pi.prd_key,pi.cat_id
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_prd_cat pc
ON pi.cat_id = pc.prd_id
WHERE pi.prd_end_dt IS NULL 

) t 
GROUP BY prd_key
HAVING COUNT(*) > 1;


-- Foreign Key Integrity (for Dimension tables)

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customer_info c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_product_info p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL;




