USE DWH;
GO

-- CRM: customer basic info
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL 
    DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cust_id INT,
    cust_key VARCHAR(35),
    cust_firstname VARCHAR(35),
    cust_lastname VARCHAR(35),
    cust_marital_status VARCHAR(35),
    cust_gender VARCHAR(35),
    cust_create_date DATE
);
GO

-- CRM: product reference information
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL 
    DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(35),
    prd_name VARCHAR(35),
    prd_cost DECIMAL(12,2),
    prd_line VARCHAR(5),
    prd_start_dt DATE,
    prd_end_dt DATE
);
GO

-- CRM: sales transactions (raw)
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL 
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(35),
    sls_prd_key VARCHAR(35),
    sls_cust_id INT,
    sls_order_dt VARCHAR(10),
    sls_ship_dt VARCHAR(10),
    sls_due_dt VARCHAR(10),
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO

-- ERP: customer demographics / identifiers
IF OBJECT_ID('bronze.erp_cust_info', 'U') IS NOT NULL 
    DROP TABLE bronze.erp_cust_info;
CREATE TABLE bronze.erp_cust_info (
    cust_id VARCHAR(35),
    birthday DATE,
    gen VARCHAR(16)
);
GO

-- ERP: location lookup
IF OBJECT_ID('bronze.erp_locations', 'U') IS NOT NULL 
    DROP TABLE bronze.erp_locations;
CREATE TABLE bronze.erp_locations (
    cust_id VARCHAR(35),
    country VARCHAR(35)
);
GO

-- ERP: product category 
IF OBJECT_ID('bronze.erp_prd_cat', 'U') IS NOT NULL 
    DROP TABLE bronze.erp_prd_cat;
CREATE TABLE bronze.erp_prd_cat (
    id  VARCHAR(35),
    cat VARCHAR(35),
    subcat VARCHAR(35),
    maintenance VARCHAR(35)
);
GO

