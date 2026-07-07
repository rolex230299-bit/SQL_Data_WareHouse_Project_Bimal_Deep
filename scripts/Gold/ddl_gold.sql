/*
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DDL Script: Create Views in gold layer
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Script Purpose:
    This script creates views in the Gold layer of the data warehouse.

    These views transform and integrate data from the Silver layer to provide
    clean, enriched, and business-ready datasets for analytical and reporting
    purposes.

Usage:
    - Query these views directly for analytics and reporting.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*/


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Create dimension table : gold.dim_customers
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

  CREATE OR ALTER VIEW gold.dim_customers AS

 SELECT 
         CAST(ROW_NUMBER() OVER(ORDER BY cst_id) AS INT) Customer_no,
		 ca.cst_id AS customer_id,
		 ca.cst_key AS customer_key,
		 ca.cst_firstname AS first_name,
		 ca.cst_lastname AS last_name,
		 cb.cntry AS Country,
		 ca.cst_marital_status AS marital_status,
		  CASE WHEN ca.cst_gndr != 'n/a' THEN ca.cst_gndr
		       ELSE  COALESCE(cc.gen,'n/a')
		  END gender,
         cc.bdate AS Birth_date,
		 ca.cst_create_date AS create_date
		 	 
 FROM silver_crm_cust_info ca
 LEFT JOIN silver_erp_loc_a101 cb
 ON ca.cst_key = cb.cid
 LEFT JOIN silver_erp_cust_az12 cc
 ON ca.cst_key = cc.cid
  GO

 -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Create dimension table : gold.dim_products
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

  CREATE OR ALTER VIEW gold.dim_products AS
  SELECT 
  CAST(ROW_NUMBER() OVER(ORDER BY cp.prd_start_dt,cp.prd_key) AS INT) product_no,
  cp.prd_id AS product_id,
  cp.prd_key AS product_key,
  cp.prd_nm AS product_name,
  cp.cat_id AS catagory_id,
  cq.cat AS catagory,
  cq.subcat AS sub_catagory,
  cp.prd_cost AS product_cost,
  cq.maintenance AS maintainance,
  cp.prd_line AS product_line,
  cp.prd_start_dt AS start_date,
  cp.prd_end_dt AS end_date
   
  FROM silver_crm_prd_info cp
  LEFT JOIN silver_erp_px_cat_g1v2 cq
  ON cp.cat_id = cq.id
  WHERE prd_end_dt IS NULL -- Filtering all hostorical data
  GO

 -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Create fact table : gold.fact_sales
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

   CREATE OR ALTER VIEW gold.fact_sales AS
  SELECT
		  ca.sls_ord_num AS order_number,
		  CAST(cb.product_no AS INT) AS product_key,
		  CAST(cc.customer_no AS INT) AS customer_key,
		  ca.sls_order_dt AS order_date,
		  ca.sls_ship_dt AS shipping_date,
		  ca.sls_due_dt AS due_date,
		  ca.sls_sales AS sales,
		  ca.sls_quantity AS quantity,
		  ca.sls_price AS price

  FROM silver_crm_sales_details ca
	  LEFT JOIN gold.dim_products cb
	  ON ca.sls_prd_key = cb.product_key
	  LEFT JOIN gold.dim_customers cc
	  ON ca.sls_cust_id = cc.customer_id
  GO
