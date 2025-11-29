-- ===============
-- Bronze CHECKING
-- ===============

SELECT * FROM bronze.crm_sales_details;

-- Checking for White Spaces in sls_ord_num (PK)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- Checking for Existing of sls_prd_key (FK) in silver.crm_prd_info
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN 
(SELECT prd_key FROM silver.crm_prd_info);

-- Checking for Existing of sls_cust_id (FK) in silver.crm_prd_info
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN 
(SELECT cst_id FROM silver.crm_cust_info);

-- sls_order_dt, sls_ship_dt, sls_due_dt are in INTEGER format

-- Checking for NULL, 0 on sls_order_dt
SELECT 
	sls_order_dt, 
	sls_ship_dt, 
	sls_due_dt 
FROM bronze.crm_sales_details
WHERE 
	(sls_order_dt <= 0 OR sls_order_dt IS NULL OR LEN(sls_order_dt) != 8) 
	OR (sls_ship_dt <= 0 OR sls_ship_dt IS NULL) 
	OR (sls_due_dt <= 0 OR sls_due_dt IS NULL)

-- Checking for the min and max on sls_order_dt, sls_ship_dt, sls_due_dt
SELECT 
    MIN(sls_order_dt) AS min_order_dt,
    MAX(sls_order_dt) AS max_order_dt,
    MIN(sls_ship_dt)  AS min_ship_dt,
    MAX(sls_ship_dt)  AS max_ship_dt,
    MIN(sls_due_dt)   AS min_due_dt,
    MAX(sls_due_dt)   AS max_due_dt
FROM bronze.crm_sales_details;


-- Checking for Invalid Date orders
SELECT 
    sls_order_dt, 
    sls_ship_dt, 
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Checking for In accurate relation between sls_sales, sls_quantity, sls_price
SELECT
	sls_sales, 
	sls_quantity, 
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price
;

-- ===============
-- Silver CHECKING
-- ===============


SELECT * FROM silver.crm_sales_details;

-- Checking for White Spaces in sls_ord_num (PK)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- Checking for Existing of sls_prd_key (FK) in silver.crm_prd_info
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

-- Checking for Existing of sls_cust_id (FK) in silver.crm_prd_info
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

-- sls_order_dt, sls_ship_dt, sls_due_dt are in INTEGER format

-- Checking for NULL, 0 on sls_order_dt
SELECT 
	sls_order_dt, 
	sls_ship_dt, 
	sls_due_dt 
FROM silver.crm_sales_details
WHERE 
	(sls_order_dt IS NULL) 
	OR (sls_ship_dt IS NULL) 
	OR (sls_due_dt IS NULL);

-- Checking for the min and max on sls_order_dt, sls_ship_dt, sls_due_dt
SELECT 
    MIN(sls_order_dt) AS min_order_dt,
    MAX(sls_order_dt) AS max_order_dt,
    MIN(sls_ship_dt)  AS min_ship_dt,
    MAX(sls_ship_dt)  AS max_ship_dt,
    MIN(sls_due_dt)   AS min_due_dt,
    MAX(sls_due_dt)   AS max_due_dt
FROM silver.crm_sales_details;


-- Checking for Invalid Date orders
SELECT 
    sls_order_dt, 
    sls_ship_dt, 
    sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Checking for In accurate relation between sls_sales, sls_quantity, sls_price
SELECT
	sls_sales, 
	sls_quantity, 
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


