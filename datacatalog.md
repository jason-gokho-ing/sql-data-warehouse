Data Catalog for Gold Layer
===============================

This document provides an overview of the Gold layer in our SQL Data Warehouse, detailing the key tables and views that store the final, curated data ready for analysis and reporting.

gold.dim_customer_info
-----------------
Column Name      | Data Type | Description
-----------------|-----------|-------------------------------
customer_key     | INT       | Unique identifier for each customer
customer_id      | INT       | Customer ID from the source system
customer_number  | VARCHAR    | Customer number from the source system
first_name      | VARCHAR    | Customer's first name
last_name       | VARCHAR    | Customer's last name
country        | VARCHAR    | Country of the customer
marital_status | VARCHAR    | Marital status of the customer
gender         | VARCHAR    | Gender of the customer
birthdate     | DATE       | Birthdate of the customer
created_date  | DATE       | Date when the customer was created


gold.dim_product_info
----------------
Column Name      | Data Type | Description
-----------------|-----------|-------------------------------
product_key      | INT       | Unique identifier for each product
product_id       | INT       | Product ID from the source system
product_number   | VARCHAR    | Product number from the source system
product_name     | VARCHAR    | Name of the product
category_id     | INT       | Category ID of the product
category        | VARCHAR    | Category of the product
subcategory     | VARCHAR    | Subcategory of the product
maintenance     | VARCHAR    | Maintenance information for the product
cost           | DECIMAL    | Price of the product
product_line  | VARCHAR    | Product line information
start_date   | DATE       | Date when the product was added

gold.fact_sales
----------------
Column Name      | Data Type | Description
-----------------|-----------|-------------------------------
order_number     | INT       | Sales order number
product_key      | INT       | Foreign key to dim_product_info
customer_key     | INT       | Foreign key to dim_customer_info
order_date      | DATE       | Date of the sales order
ship_date       | DATE       | Date when the order was shipped
quantity        | INT       | Quantity of products sold
sales_date     | DATE       | Date of the sale
sales_amount       | DECIMAL    | Total sales amount
quantity           | INT       | Total quantity sold
price              | DECIMAL    | Price per unit

This catalog serves as a reference for understanding the structure and content of the Gold layer, facilitating effective data analysis and reporting.