
USE DWH;
GO

-- Stored Procedure created to save time on loading data from tables
CREATE OR ALTER PROCEDURE bronze.bronze_load_table_data AS

BEGIN


-- start time and end time variables are used to track the speed of the loading process
DECLARE @start_time DATETIME, @end_time DATETIME
-- using TRY CATCH to handle any errors during the bulk insert process
    BEGIN TRY 
        PRINT 'Loading Data into CRM Customer Info Table';
        -- Inserting data into crm_cust_info table
        TRUNCATE TABLE bronze.crm_cust_info; 
        -- truncate prevents duplicate inserts if run multiple times
        BULK INSERT bronze.crm_cust_info 
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Inserting data into crm_prd_info table
        PRINT 'Loading Data into CRM Product Info Table';
        TRUNCATE TABLE bronze.crm_prd_info; 
        BULK INSERT bronze.crm_prd_info 
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Inserting data into crm_sales_details table
        PRINT 'Loading Data into CRM Sales Details Table';
        TRUNCATE TABLE bronze.crm_sales_details; 
        BULK INSERT bronze.crm_sales_details 
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        -- Inserting data into erp_cust_info table
        PRINT 'Loading Data into ERP Customer Info Table';
        TRUNCATE TABLE bronze.erp_cust_info;    
        BULK INSERT bronze.erp_cust_info
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        -- Inserting data into erp_locations table
        PRINT 'Loading Data into ERP Locations Table';
        TRUNCATE TABLE bronze.erp_locations;
        BULK INSERT bronze.erp_locations
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_locations.csv'
        WITH (  
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Inserting data into erp_prd_cat table
        PRINT 'Loading Data into ERP Product Category Table';
        TRUNCATE TABLE bronze.erp_prd_cat;
        BULK INSERT bronze.erp_prd_cat
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_prd_cat.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

    END TRY

    BEGIN CATCH
        PRINT 'Error Occurred During Bronze Layer Loading Process';
        PRINT 'Error Message' + ERROR_MESSAGE();
    END CATCH

END