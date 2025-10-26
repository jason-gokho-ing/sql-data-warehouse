USE DWH;

GO


-- Combine all data on customers together using CRM Customer Information Table with ERP Locations and ERP Customer Info Tables

IF OBJECT_ID('gold.dim_customer_info','V') IS NOT NULL
       DROP VIEW gold.dim_customer_info;
       GO

CREATE VIEW gold.dim_customer_info AS (
       SELECT
       ROW_NUMBER() OVER (ORDER BY ci.cust_id ) AS customer_key, -- create surrogate key for customer dimension table
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
              CASE 
                     WHEN ei.birthday IS NULL THEN ''
                     ELSE ei.birthday
                     END AS birth_date,
              ci.cust_create_date AS created_date
       FROM silver.crm_cust_info ci
              LEFT JOIN silver.erp_cust_info ei
              ON ci.cust_key = ei.cust_key
              LEFT JOIN silver.erp_locations loc
              ON ci.cust_key = loc.cust_key
);
GO

-- Create Gold Layer Product Information Table from CRM Product Information & ERP Product Category Table
IF OBJECT_ID('gold.dim_product_info','V') IS NOT NULL
       DROP VIEW gold.dim_product_info;
       GO

CREATE VIEW gold.dim_product_info AS (
       SELECT 
              ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key, -- create surrogate key for product dimension table
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
);
GO

-- Put the surrogate keys in the fact table
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
       DROP VIEW gold.fact_sales;
       GO

CREATE VIEW gold.fact_sales AS (
       SELECT 
              sd.sls_ord_num AS order_number,
              prd.product_key,
              cus.customer_key,
              sd.sls_order_dt AS order_date,
              sd.sls_ship_dt AS ship_date,
              sd.sls_due_dt AS due_date,
              sd.sls_sales AS sales,
              sd.sls_quantity AS quantity,
              sd.sls_price AS price
       FROM silver.crm_sales_details sd
              LEFT JOIN gold.dim_customer_info cus
              ON sd.sls_cust_id = cus.customer_id
              LEFT JOIN gold.dim_product_info prd
              ON sd.sls_prd_key = prd.product_number
       WHERE sd.sls_order_dt IS NOT NULL -- Filter out records with null order date
);
GO

select * from gold.fact_sales;
select * from gold.dim_customer_info;
SELECT * FROM gold.dim_product_info;