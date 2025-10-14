USE DWH;
GO

EXEC bronze.bronze_load_table_data; 

SELECT * FROM bronze.bronze_customers;
GO
SELECT * FROM bronze.bronze_orders;
GO
SELECT * FROM bronze.bronze_order_items;
GO
SELECT * FROM bronze.bronze_products;
GO
SELECT * FROM bronze.bronze_suppliers;
GO
SELECT * FROM bronze.bronze_categories;