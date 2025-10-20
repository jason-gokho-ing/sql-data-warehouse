USE DWH;
GO

-- Clean data and insert it into the Silver layer

CREATE OR ALTER PROCEDURE silver.silver_load_table_data AS
BEGIN 
    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @start_batch_time DATETIME, @end_batch_time DATETIME;

    -- Used to measure the time taken for the Whole Batch to load
    SET @start_batch_time = GETDATE();

    BEGIN TRY 
    -- CRM: cust_info table
    SET @start_time = GETDATE();
    TRUNCATE TABLE silver.crm_cust_info;
    PRINT 'Inserting Data into silver.crm_cust_info';
    INSERT INTO silver.crm_cust_info (
        cust_id, cust_key, cust_firstname, cust_lastname, cust_gender, cust_marital_status, cust_create_date
    )
        -- Check for unwanted spaces (TRIM function)
        SELECT 
            cust_id, 
            cust_key, 
            TRIM(cust_firstname) AS cust_firstname, 
            TRIM(cust_lastname) AS cust_lastname, 
            -- Clarify abbreviated values with CASE statements (e.g., M = Male, Null = N/A, etc.)
            CASE 
                WHEN UPPER(TRIM(cust_gender)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cust_gender)) = 'M' THEN 'Male'
                ELSE 'N/A'
            END AS cust_gender,
            CASE 
                WHEN UPPER(TRIM(cust_marital_status)) = 'M' THEN 'Married'
                WHEN UPPER(TRIM(cust_marital_status)) = 'S' THEN 'Single'
                ELSE 'N/A'
            END AS cust_marital_status,
            cust_create_date
        FROM (
            -- Make sure that there are no duplicate customer IDs
            SELECT *, 
                ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_create_date DESC) AS recent_duplicate
            FROM bronze.crm_cust_info
            WHERE cust_id IS NOT NULL
        ) duplicate_checker
        WHERE recent_duplicate = 1;

    SET @end_time = GETDATE();
    PRINT 'Time taken to load silver.crm_cust_info: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
    PRINT '';

    -- CRM: product info table
    SET @start_time = GETDATE();
    TRUNCATE TABLE silver.crm_prd_info;
    PRINT 'Inserting Data into silver.crm_prd_info';
    INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_name, prd_cost, prd_line, prd_start_dt, prd_end_dt)
    SELECT 
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id, -- Replacing all '-' with '_'
        SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Using sub-string function to isolate portion of prd_key to match other table
        prd_name,
        COALESCE(prd_cost, 0) AS prd_cost, -- Replace NULL Values with 0
        CASE UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'N/A'
        END AS prd_line,
        prd_start_dt,
        CAST(DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS DATE) AS prd_end_dt
    FROM bronze.crm_prd_info;
    SET @end_time = GETDATE();
    PRINT 'Time taken to load silver.crm_prd_info: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
    PRINT '';

    -- CRM: Sales Details
    SET @start_time = GETDATE();
    TRUNCATE TABLE silver.crm_sales_details;
    PRINT 'Inserting Data into silver.crm_sales_details';
    INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
    -- Using CASE to catch non-valid dates. Transform variables from VARCHAR to DATE
        CASE WHEN LEN(sls_order_dt) != 8 THEN NULL
            ELSE CAST(sls_order_dt AS DATE)
        END AS sls_order_dt,
        CASE WHEN LEN(sls_ship_dt) != 8 THEN NULL
            ELSE CAST(sls_ship_dt AS DATE)
        END AS sls_ship_dt,
        CASE WHEN LEN(sls_due_dt) != 8 THEN NULL
            ELSE CAST(sls_due_dt AS DATE)
        END AS sls_due_dt,
    -- Using CASE to handle NULL, zero, or negative sales and price values
        CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE WHEN sls_price IS NULL OR sls_price <= 0 
            THEN sls_sales / NULLIF(sls_quantity,0)
            ELSE sls_price
        END AS sls_price
    FROM bronze.crm_sales_details;
    SET @end_time = GETDATE();
    PRINT 'Time taken to load silver.crm_sales_details: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
    PRINT '';

    -- bronze.erp_cust_info
    SET @start_time = GETDATE();
    TRUNCATE TABLE silver.erp_cust_info;
    PRINT 'Inserting Data into silver.erp_cust_info';
    INSERT INTO silver.erp_cust_info (cust_id, birthday, gender)
    SELECT 
    -- Clean customer ID by removing 'NAS' prefix if it exists
        CASE WHEN cust_id LIKE 'NAS%' 
            THEN SUBSTRING(cust_id, 4, LEN(cust_id)) 
            ELSE cust_id 
        END AS cust_id, 
        CASE WHEN birthday > GETDATE() THEN NULL -- Set future birthdays as NULL
            ELSE birthday
        END AS birthday,
        CASE 
            WHEN UPPER(LTRIM(RTRIM(gender))) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(LTRIM(RTRIM(gender))) IN ('M', 'MALE') THEN 'Male'
            ELSE 'N/A'
        END AS gender
    FROM bronze.erp_cust_info;
    SET @end_time = GETDATE();
    PRINT 'Time taken to load silver.erp_cust_info: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
    PRINT '';

    -- bronze.erp_locations
    SET @start_time = GETDATE();
    TRUNCATE TABLE silver.erp_locations;
    PRINT 'Inserting Data into silver.erp_locations';
    INSERT INTO silver.erp_locations (cust_id, country)
    SELECT 
        (REPLACE(cust_id,'-','')) AS cust_id,
        CASE 
            WHEN UPPER(LTRIM(RTRIM(country))) IN ('US', 'UNITED STATES') THEN 'United States'
            WHEN UPPER(LTRIM(RTRIM(country))) IN ('UK', 'UNITED KINGDOM') THEN 'United Kingdom'
            WHEN UPPER(LTRIM(RTRIM(country))) IN ('DE', 'GERMANY') THEN 'Germany'
            WHEN UPPER(LTRIM(RTRIM(country))) IN ('CANADA') THEN 'Canada'
            WHEN UPPER(LTRIM(RTRIM(country))) IN ('AUSTRALIA') THEN 'Australia'
            WHEN UPPER(LTRIM(RTRIM(country))) IN ('FRANCE') THEN 'France'       
            ELSE 'N/A'
        END AS country -- Normalize and Handle missing or blank country codes
    FROM bronze.erp_locations;
    SET @end_time = GETDATE();
    PRINT 'Time taken to load silver.erp_locations: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
    PRINT '';

    -- bronze.erp_prd_cat
    SET @start_time = GETDATE();
    TRUNCATE TABLE silver.erp_prd_cat;
    PRINT 'Inserting Data into silver.erp_prd_cat';
    INSERT INTO silver.erp_prd_cat (prd_id, cat, subcat, maintenance)
    SELECT prd_id, 
        cat, 
        subcat, 
        maintenance 
    FROM bronze.erp_prd_cat;
    SET @end_time = GETDATE();
    PRINT 'Time taken to load silver.erp_prd_cat: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
    PRINT '';

    SET @end_batch_time = GETDATE();
    PRINT 'Time taken to load Entire Silver Layer: ' + CAST(DATEDIFF(second, @start_batch_time, @end_batch_time) AS VARCHAR) + ' seconds';

END TRY

    BEGIN CATCH
        PRINT 'Error Occurred During Bronze Layer Loading Process';
        PRINT 'Error Message' + ERROR_MESSAGE();
    END CATCH
END

exec silver.silver_load_table_data