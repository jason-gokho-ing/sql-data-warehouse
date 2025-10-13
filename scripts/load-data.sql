
USE DWH;
GO

-- Inserting data into crm_cust_info table
TRUNCATE TABLE bronze.crm_cust_info; 
-- truncate prevents duplicate inserts if run multiple times
BULK INSERT bronze.crm_cust_info 
FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
)
GO

-- Inserting data into crm_prd_info table
TRUNCATE TABLE bronze.crm_prd_info; 
BULK INSERT bronze.crm_prd_info 
FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
)
GO

-- Inserting data into crm_sales_details table
TRUNCATE TABLE bronze.crm_sales_details; 
BULK INSERT bronze.crm_sales_details 
FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
)
GO

-- Inserting data into erp_cust_info table
TRUNCATE TABLE bronze.erp_cust_info;    
BULK INSERT bronze.erp_cust_info
FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
)
GO
-- Inserting data into erp_locations table
TRUNCATE TABLE bronze.erp_locations;    
BULK INSERT bronze.erp_locations
FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_locations.csv'
WITH (  
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
)
GO

-- Inserting data into erp_prd_cat table
TRUNCATE TABLE bronze.erp_prd_cat;
BULK INSERT bronze.erp_prd_cat
FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_product_categories.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
)
GO

