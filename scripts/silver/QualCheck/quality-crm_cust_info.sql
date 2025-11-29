-- ===============
-- Bronze CHECKING
-- ===============

SELECT * FROM bronze.crm_cust_info

-- CHECKING FOR DUBPLICATE in cst_id (Primarykey)
SELECT cst_id, COUNT(*) count_cst_id
FROM bronze.crm_cust_info 
GROUP BY cst_id
HAVING COUNT(*) > 1 ;

-- CHECKING FOR UNWANTED SPACES in cst_firstname
SELECT cst_firstname 
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- CHECKING FOR UNWANTED SPACES in cst_lastname
SELECT cst_lastname 
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Also you can check unwanted spaces on cst_marital_status and cst_gndr but the quality are clear so I'm just gonna leave it.

-- cst_marital_status Options
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

-- cst_gndr Options
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;


-- ===============
-- Silver CHECKING
-- ===============


SELECT * FROM silver.crm_cust_info

-- CHECKING FOR DUBPLICATE in cst_id (Primarykey)
SELECT cst_id, COUNT(*) count_cst_id
FROM silver.crm_cust_info 
GROUP BY cst_id
HAVING COUNT(*) > 1 ;

-- CHECKING FOR UNWANTED SPACES in cst_firstname
SELECT cst_firstname 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- CHECKING FOR UNWANTED SPACES in cst_lastname
SELECT cst_lastname 
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Also you can check unwanted spaces on cst_marital_status and cst_gndr but the quality are clear so I'm just gonna leave it.

-- cst_marital_status Options
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- cst_gndr Options
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;


