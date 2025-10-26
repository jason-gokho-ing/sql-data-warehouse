USE master;
GO

-- Drop and recreate the 'DWH' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DWH')
BEGIN
    ALTER DATABASE DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DWH;
END;
GO

-- Create the 'DWH' database
CREATE DATABASE DWH;
GO

USE DWH;
GO

-- Creating Schemas within database to organize data warehouse

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
 
 





