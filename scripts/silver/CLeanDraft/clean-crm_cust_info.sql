-- CLEANING Dubs in cst_id
SELECT *
FROM (
SELECT 
	*, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) T WHERE flag_last > 1;

-- CLEANING WHITE SPACES IN cst_firstname and cst_lastname
	-- CLEANING Dubs in cst_id + TRIM()
SELECT 
	cst_id,
	cst_key,
	TRIM( cst_firstname ) AS cst_firstname, 
	TRIM( cst_lastname ) AS cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM (
SELECT 
	*, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) T WHERE flag_last = 1;

-- CHANGE Options in cst_gndr and cst_marital_status
	-- CLEANING WHITE SPACES IN cst_firstname and cst_lastname + ( cst_marital_status, cst_gndr)
SELECT 
	cst_id,
	cst_key,
	TRIM( cst_firstname ) AS cst_firstname, 
	TRIM( cst_lastname ) AS cst_lastname,
	CASE cst_marital_status
		WHEN 'M' THEN 'Married'
		WHEN 'S' THEN 'Single'
		ELSE 'n/a'
	END cst_marital_status,
	CASE cst_gndr
		WHEN 'F' THEN 'Female'
		WHEN 'M' THEN 'Male'
		ELSE 'n/a'
	END cst_gndr,
	cst_create_date
FROM (
SELECT 
	*, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) T WHERE flag_last = 1;

-- INSERT THE CLEANED DATA INTO silver layer
	-- CHANGE Options in cst_gndr and cst_marital_status + INSERT INTO silver

INSERT INTO silver.crm_cust_info ( cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date , )

SELECT 
	cst_id,
	cst_key,
	TRIM( cst_firstname ) AS cst_firstname, 
	TRIM( cst_lastname ) AS cst_lastname,
	CASE cst_marital_status
		WHEN 'M' THEN 'Married'
		WHEN 'S' THEN 'Single'
		ELSE 'n/a'
	END cst_marital_status,
	CASE cst_gndr
		WHEN 'F' THEN 'Female'
		WHEN 'M' THEN 'Male'
		ELSE 'n/a'
	END cst_gndr,
	cst_create_date
FROM (
SELECT 
	*, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) T WHERE flag_last = 1;

