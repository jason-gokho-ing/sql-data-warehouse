-- Create Database 'DWH'

USE master;

-- Drop database if it already exists
ALTER DATABASE DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE DWH;

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
 
 





