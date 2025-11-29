-- Extracting cat_id from prd_key
SELECT
	prd_id,
	prd_key,
	REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

-- Extracting prd_key from prd_key (Format is wrong)
   -- Extracting cat_id from prd_key + new prd_key
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
FROM bronze.crm_prd_info;

-- Replacing NULL with 0 IN prd_cost
   -- Extracting prd_key from prd_key (Format is wrong) + NULL to 0
   SELECT
	prd_id,
	prd_key,
	REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,
	prd_nm,
	COALESCE(prd_cost,0) AS prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

-- Full name for prd_line
   -- Replacing NULL with 0 IN prd_cost + CASE WHEN
SELECT
	prd_id,
	prd_key,
	REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
	SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,
	prd_nm,
	COALESCE(prd_cost,0) AS prd_cost,
	CASE UPPER(TRIM(prd_line)) 
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

-- Fixing wrong Date Order
	-- Sample 1 'AC-HE-HL-U509-R' and 'AC-HE-HL-U509'
	SELECT
		prd_id,
		prd_key,
		prd_nm,
		prd_start_dt,
		prd_end_dt,
		LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
	FROM bronze.crm_prd_info
	WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');

	-- TO ALL DATA
	SELECT
		prd_id,
		prd_key,
		REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
		SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,
		prd_nm,
		COALESCE(prd_cost,0) AS prd_cost,
		CASE UPPER(TRIM(prd_line)) 
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END prd_line,
		CAST(prd_start_dt AS DATE),
		CAST( LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
	FROM bronze.crm_prd_info;

-- INSERT THE CLEANED DATA INTO silver layer
	-- Fixing wrong Date Order To All DATA + INSERT
	INSERT INTO silver.crm_prd_info( prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
	SELECT
		prd_id,
		REPLACE( SUBSTRING(prd_key,1, 5), '-', '_' ) AS cat_id,
		SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key,
		prd_nm,
		COALESCE(prd_cost,0) AS prd_cost,
		CASE UPPER(TRIM(prd_line)) 
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END prd_line,
		CAST(prd_start_dt AS DATE),
		CAST( LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
	FROM bronze.crm_prd_info;