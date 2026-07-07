 /*

# Stored Procedure: Load Bronze Layer (Source -> Bronze)

Script Purpose:
This stored procedure loads data from external CSV files into the 'bronze'
schema. It performs the following actions:
- Truncates the bronze tables before loading data.
- Uses the BULK INSERT command to load data from CSV files into the bronze tables.

Parameters:
None.
This stored procedure does not accept any parameters and does not return any values.

Usage Example:
EXEC bronze.load_bronze;
========================

*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME , @batch_end_time DATETIME
  BEGIN TRY
    PRINT'======================';
    PRINT'Loading Bronze Layer';
	PRINT'======================';

	PRINT'----------------------';
	PRINT'lOADING CRM TABLE';
	PRINT'----------------------';

	SET @batch_start_time = GETDATE();
	SET @start_time = GETDATE();
	PRINT'>> Truncating the table : bronze_crm_cust_info';
	TRUNCATE TABLE bronze_crm_cust_info;

	PRINT'>> Inserting data into table : bronze_crm_cust_info';
	BULK INSERT bronze_crm_cust_info
	FROM 'C:\Users\asus\Desktop\SQL PROJECT\source_crm\cust_info.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating the table : bronze_crm_prd_info';
	TRUNCATE TABLE bronze_crm_prd_info;

	PRINT'>> Inserting data into table : bronze_crm_prd_info';
	BULK INSERT bronze_crm_prd_info
	FROM 'C:\Users\asus\Desktop\SQL PROJECT\source_crm\prd_info.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating the table : bronze_crm_sales_details';
	TRUNCATE TABLE bronze_crm_sales_details;

	PRINT'>> Inserting data into table : bronze_crm_sales_details';
	BULK INSERT bronze_crm_sales_details
	FROM 'C:\Users\asus\Desktop\SQL PROJECT\source_crm\sales_details.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';

	PRINT'----------------------';
	PRINT'lOADING ERP TABLE';
	PRINT'----------------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating the table : bronze_erp_cust_az12';
	TRUNCATE TABLE bronze_erp_cust_az12;

	PRINT'>> Inserting data into table : bronze_erp_cust_az12';
	BULK INSERT bronze_erp_cust_az12
	FROM 'C:\Users\asus\Desktop\SQL PROJECT\source_erp\CUST_AZ12.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating the table : bronze_erp_loc_a101';
	TRUNCATE TABLE bronze_erp_loc_a101;

	PRINT'>> Inserting data into table : bronze_erp_loc_a101';
	BULK INSERT bronze_erp_loc_a101
	FROM 'C:\Users\asus\Desktop\SQL PROJECT\source_erp\LOC_A101.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating the table : bronze_erp_px_cat_g1v2';
	TRUNCATE TABLE bronze_erp_px_cat_g1v2;

	PRINT'>> Inserting data into table : bronze_erp_px_cat_g1v2';
	BULK INSERT bronze_erp_px_cat_g1v2
	FROM 'C:\Users\asus\Desktop\SQL PROJECT\source_erp\PX_CAT_G1V2.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';

	SET @batch_end_time = GETDATE();
	PRINT'=========================================================================================';
	PRINT'Loading bronze layer is completed';
    PRINT '>> total load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';
	PRINT'==========================================================================================';
	
	END TRY
	 BEGIN CATCH
	 PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	 END CATCH
END
