
USE DWH;

-- Inserting data into crm_cust_info table
BULK INSERT bronze.crm_cust_info 
FROM 'C:\Users\jason\Documents\SQL Server Management Studio 21\sql-data-warehouse\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
)

SELECT * FROM  bronze.crm_cust_info;

