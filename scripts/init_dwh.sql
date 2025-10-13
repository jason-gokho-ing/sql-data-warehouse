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
 
 





