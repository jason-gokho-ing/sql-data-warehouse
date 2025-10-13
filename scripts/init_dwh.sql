-- Create Database 'DWH'

USE master;

DROP DATABASE IF EXISTS DWH;
CREATE DATABASE DWH;


USE DWH;
GO

-- Creating Schemas within database to organize data warehouse

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
 
 

-- CRM: customer basic info
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL DROP TABLE bronze.cust_info;
CREATE TABLE bronze.cust_info (
	cst_id INT NOT NULL PRIMARY KEY,
	cst_key VARCHAR(50) NOT NULL,
	cst_firstname VARCHAR(100) NULL,
	cst_lastname VARCHAR(100) NULL,
	cst_marital_status CHAR(1) NULL,
	cst_gndr CHAR(1) NULL,
	cst_create_date DATE NULL
);
GO

-- CRM: product reference information
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL DROP TABLE bronze.prd_info;
CREATE TABLE bronze.prd_info (
	prd_id INT NOT NULL PRIMARY KEY,
	prd_key VARCHAR(80) NOT NULL,
	prd_nm VARCHAR(250) NULL,
	prd_cost DECIMAL(12,2) NULL,
	prd_line CHAR(5) NULL,
	prd_start_dt DATE NULL,
	prd_end_dt DATE NULL
);
GO

-- CRM: sales transactions (raw)
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.sales_details (
	sls_ord_num VARCHAR(50) NOT NULL PRIMARY KEY,
	sls_prd_key VARCHAR(80) NULL,
	sls_cust_id INT NULL,
	-- source file uses YYYYMMDD integer format for dates; convert on load.
	sls_order_dt VARCHAR(10) NULL,
	sls_ship_dt VARCHAR(10) NULL,
	sls_due_dt VARCHAR(10) NULL,
	sls_sales DECIMAL(14,2) NULL,
	sls_quantity INT NULL,
	sls_price DECIMAL(12,2) NULL
);
GO

-- ERP: customer demographics / identifiers
IF OBJECT_ID('bronze.erp_cust_info', 'U') IS NOT NULL DROP TABLE bronze.erp_cust;
CREATE TABLE bronze.erp_cust (
	cid VARCHAR(80) NOT NULL PRIMARY KEY,
	bdate DATE NULL,
	gen VARCHAR(16) NULL
);
GO

-- ERP: location lookup
IF OBJECT_ID('bronze.erp_loc', 'U') IS NOT NULL DROP TABLE bronze.erp_loc;
CREATE TABLE bronze.loc (
	cid VARCHAR(80) NOT NULL PRIMARY KEY,
	cntry VARCHAR(100) NULL
);
GO

-- ERP: product category 
IF OBJECT_ID('bronze.erp_product_category', 'U') IS NOT NULL DROP TABLE bronze.erp_product_category;
CREATE TABLE bronze.erp_product_category (
	id VARCHAR(50) NOT NULL PRIMARY KEY,
	cat VARCHAR(120) NULL,
	subcat VARCHAR(200) NULL,
	maintenance BIT NULL -- 1 = Yes, 0 = No; convert during load
);
GO



