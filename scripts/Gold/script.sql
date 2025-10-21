USE DWH;

GO


-- Combine all data on customers together using CRM Customer Information Table with ERP Locations and ERP Customer Info Tables
CREATE VIEW gold.customer_info AS (
       SELECT
       ROW_NUMBER() OVER (ORDER BY ci.cust_id ) AS customer_key,
              ci.cust_id AS customer_id, 
              ci.cust_key AS customer_number, 
              ci.cust_firstname AS first_name, 
              ci.cust_lastname AS last_name, 
              loc.country AS country,
              ci.cust_marital_status AS marital_status, 
              CASE 
                     WHEN ci.cust_gender != 'N/A' THEN ci.cust_gender 
                     ELSE COALESCE(ci.cust_gender, 'N/A')  
                     END AS gender,
              ei.birthday AS birthdate,
              ci.cust_create_date AS created_date
       FROM silver.crm_cust_info ci
              LEFT JOIN silver.erp_cust_info ei
              ON ci.cust_key = ei.cust_key
              LEFT JOIN silver.erp_locations loc
              ON ci.cust_key = loc.cust_key
);
GO

-- Create Gold Layer Product Information Table from CRM Product Information & ERP Product Category Table
CREATE VIEW gold.product_info AS (
       SELECT 
              ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key,
              pi.prd_id AS product_id,
              pi.prd_key AS product_number,
              pi.prd_name AS product_name,
              pi.cat_id AS category_id,
              pc.cat AS category,
              pc.subcat AS subcategory,
              pc.maintenance,
              pi.prd_cost AS cost,
              pi.prd_line AS product_line,
              pi.prd_start_dt AS start_date
       FROM silver.crm_prd_info pi
       LEFT JOIN silver.erp_prd_cat pc
       ON pi.cat_id = pc.prd_id
       WHERE pi.prd_end_dt IS NULL -- Filter out all historical products
)