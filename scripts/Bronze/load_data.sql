
USE DWH;
GO

-- Bronze Layer Data Load Procedure
-- Loads data from CSV files into bronze layer tables and prints time taken for each load

CREATE OR ALTER PROCEDURE bronze.bronze_load_table_data AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @start_batch_time DATETIME, @end_batch_time DATETIME;

    -- Used to measure the time taken for the Whole Batch to load
     SET @start_batch_time = GETDATE();

    BEGIN TRY 
        -- CRM Customer Info
        PRINT 'Loading Data into CRM Customer Info Table';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info; 
        BULK INSERT bronze.crm_cust_info 
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load CRM Customer Info Table: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

        PRINT '';

        -- CRM Product Info
        PRINT 'Loading Data into CRM Product Info Table';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info; 
        BULK INSERT bronze.crm_prd_info 
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load CRM Product Info Table: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

        PRINT '';

        -- CRM Sales Details
        PRINT 'Loading Data into CRM Sales Details Table';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details; 
        BULK INSERT bronze.crm_sales_details 
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\crm_sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load CRM Sales Details Table: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

        PRINT '';

        -- ERP Customer Info
        PRINT 'Loading Data into ERP Customer Info Table';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_info;    
        BULK INSERT bronze.erp_cust_info
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load ERP Customer Info Table: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

        PRINT '';

        -- ERP Locations
        PRINT 'Loading Data into ERP Locations Table';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_locations;
        BULK INSERT bronze.erp_locations
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_locations.csv'
        WITH (  
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load ERP Locations Table: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

        PRINT '';

        -- ERP Product Category
        PRINT 'Loading Data into ERP Product Category Table';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_prd_cat;
        BULK INSERT bronze.erp_prd_cat
        FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_erp\erp_prd_cat.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load ERP Product Category Table: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '';

    SET @end_batch_time = GETDATE();
    PRINT 'Time taken to load Entire Bronze Layer: ' + CAST(DATEDIFF(second, @start_batch_time, @end_batch_time) AS VARCHAR) + ' seconds';
    END TRY
    

    BEGIN CATCH
        PRINT 'Error Occurred During Bronze Layer Loading Process';
        PRINT 'Error Message' + ERROR_MESSAGE();
    END CATCH
END
