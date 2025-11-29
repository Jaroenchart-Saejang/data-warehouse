-- ===============
-- Bronze CHECKING
-- ===============

SELECT cid, bdate, gen FROM bronze.erp_cust_az12;

-- CHECKING for Collumn WITH NAS Pattern
SELECT cid, bdate, gen
FROM bronze.erp_cust_az12
WHERE cid LIKE 'NAS%'

-- CHECKING for rows that are in erp_cust_az12 but not in crm_cust_info
SELECT 
	cid,
	CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4, LEN(cid))
		ELSE cid
	END AS cid,
	bdate, 
	gen
FROM bronze.erp_cust_az12
WHERE CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4, LEN(cid))
		ELSE cid
	END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

-- Checking NULL, MAX MIN MED in bdate
SELECT DISTINCT
    MIN(bdate) OVER () AS min_birthdate,
    MAX(bdate) OVER () AS max_birthdate,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY bdate) OVER () AS median_birthdate,
    SUM(CASE WHEN bdate IS NULL THEN 1 ELSE 0 END) OVER () AS null_count
FROM bronze.erp_cust_az12

-- CHECKING for impossible dbate
SELECT 
*
FROM bronze.erp_cust_az12
WHERE bdate > GETDATE();


-- CHECK OPTIONS for Gender
SELECT DISTINCT gen FROM bronze.erp_cust_az12;
