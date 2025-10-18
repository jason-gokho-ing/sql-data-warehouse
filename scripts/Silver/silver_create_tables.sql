USE DWH;
GO

-- CRM: customer basic info
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL 
    DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cust_id INT,
    cust_key VARCHAR(35),
    cust_firstname VARCHAR(35),
    cust_lastname VARCHAR(35),
    cust_marital_status VARCHAR(35),
    cust_gender VARCHAR(35),
    cust_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- CRM: product reference information
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL 
    DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id VARCHAR(35),
    prd_key VARCHAR(35),
    prd_name VARCHAR(35),
    prd_cost DECIMAL(12,2),
    prd_line VARCHAR(35),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- CRM: sales transactions (raw)
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL 
    DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(35),
    sls_prd_key VARCHAR(35),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales DECIMAL(12,2),
    sls_quantity INT,
    sls_price DECIMAL(12,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ERP: customer demographics / identifiers
IF OBJECT_ID('silver.erp_cust_info', 'U') IS NOT NULL 
    DROP TABLE silver.erp_cust_info;
CREATE TABLE silver.erp_cust_info (
    cust_id VARCHAR(35),
    birthday DATE,
    gender VARCHAR(16),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ERP: location lookup
IF OBJECT_ID('silver.erp_locations', 'U') IS NOT NULL 
    DROP TABLE silver.erp_locations;
CREATE TABLE silver.erp_locations (
    cust_id VARCHAR(35),
    country VARCHAR(35),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ERP: product category 
IF OBJECT_ID('silver.erp_prd_cat', 'U') IS NOT NULL 
    DROP TABLE silver.erp_prd_cat;
CREATE TABLE silver.erp_prd_cat (
    id  VARCHAR(35),
    cat VARCHAR(35),
    subcat VARCHAR(35),
    maintenance VARCHAR(35),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

