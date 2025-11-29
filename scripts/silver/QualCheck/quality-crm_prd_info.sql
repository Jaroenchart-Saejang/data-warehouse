-- ===============
-- Bronze CHECKING
-- ===============

SELECT * FROM bronze.crm_prd_info;

-- CHECKING FOR DUBPLICATE in prd_id (Primary-key)
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL;

-- prd_key ------> cat_id FROM erp_px_cat_g1v2 
		   ------> product_key FROM erp_px_cat_g1v2 

-- Find the category_id that is in crm_prd_info but not in the erp_px_cat_g1v2
SELECT
	prd_id,
	prd_key,
	REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) NOT IN 
(SELECT distinct id FROM bronze.erp_px_cat_g1v2);

-- Find the Product KEY that is in crm_prd_info but not in the crm_sales_details (Products that do not have any sale yet)
SELECT
	prd_id,
	prd_key,
	REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key,7, LEN(prd_key)) NOT IN
(SELECT distinct sls_prd_key FROM bronze.crm_sales_details);

-- Check for the unwanted Spaces in prd_nm
SELECT * FROM bronze.crm_prd_info
WHERE prd_nm ! = TRIM(prd_nm);

-- Check for Null of Negative Number in prd_cost
SELECT * FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0;

-- Check for Option in prd_line
SELECT DISTINCT prd_line FROM bronze.crm_prd_info;

-- Checkl for NULL prd_start_dt
SELECT prd_start_dt FROM bronze.crm_prd_info
WHERE prd_start_dt IS NULL;

-- Check for Invalid Date Orders (ผิดลำดับ)
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ===============
-- Silver CHECKING
-- ===============

SELECT * FROM silver.crm_prd_info;

-- CHECKING FOR DUBPLICATE in prd_id (Primary-key)
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL;

-- prd_key ------> cat_id FROM erp_px_cat_g1v2 
		   ------> product_key FROM erp_px_cat_g1v2 

-- Find the category_id that is in crm_prd_info but not in the erp_px_cat_g1v2
SELECT
	prd_id,
	prd_key,
	REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) NOT IN 
(SELECT distinct id FROM silver.erp_px_cat_g1v2);

-- Find the Product KEY that is in crm_prd_info but not in the crm_sales_details (Products that do not have any sale yet)
SELECT
	prd_id,
	prd_key,
	REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE SUBSTRING(prd_key,7, LEN(prd_key)) NOT IN
(SELECT distinct sls_prd_key FROM silver.crm_sales_details);

-- Check for the unwanted Spaces in prd_nm
SELECT * FROM silver.crm_prd_info
WHERE prd_nm ! = TRIM(prd_nm);

-- Check for Null of Negative Number in prd_cost
SELECT * FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0;

-- Check for Option in prd_line
SELECT DISTINCT prd_line FROM silver.crm_prd_info;

-- Checkl for NULL prd_start_dt
SELECT prd_start_dt FROM silver.crm_prd_info
WHERE prd_start_dt IS NULL;

-- Check for Invalid Date Orders (ผิดลำดับ)
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;
