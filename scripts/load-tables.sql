USE DWH;
GO

-- CRM: customer basic info
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL 
    DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gender NVARCHAR(50),
    cst_create_date DATE
);
GO

-- CRM: product reference information
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL 
    DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(80),
    prd_nm VARCHAR(250),
    prd_cost DECIMAL(12,2),
    prd_line CHAR(5),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);
GO

-- CRM: sales transactions (raw)
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL 
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(80),
    sls_cust_id INT,
    sls_order_dt NVARCHAR(10),
    sls_ship_dt NVARCHAR(10),
    sls_due_dt NVARCHAR(10),
    sls_sales DECIMAL(14,2),
    sls_quantity INT,
    sls_price DECIMAL(12,2)
);
GO

-- ERP: customer demographics / identifiers
IF OBJECT_ID('bronze.erp_cust_info', 'U') IS NOT NULL 
    DROP TABLE bronze.erp_cust_info;
CREATE TABLE bronze.erp_cust_info (
    cid NVARCHAR(80),
    bdate DATE,
    gen VARCHAR(16)
);
GO

-- ERP: location lookup
IF OBJECT_ID('bronze.erp_locations', 'U') IS NOT NULL 
    DROP TABLE bronze.erp_locations;
CREATE TABLE bronze.erp_locations (
    cid NVARCHAR(80),
    cntry NVARCHAR(100)
);
GO

-- ERP: product category 
IF OBJECT_ID('bronze.erp_prd_cat', 'U') IS NOT NULL 
    DROP TABLE bronze.erp_prd_cat;
CREATE TABLE bronze.erp_prd_cat (
    id  NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO

