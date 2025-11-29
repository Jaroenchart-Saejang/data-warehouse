-- CHANGING 0 OR LEN != 8 TO NULL in sls_order_dt
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
		ELSE CAST( CAST( sls_order_dt AS VARCHAR ) AS DATE)
	END AS sls_order_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details

-- CHANGING 0 OR LEN != 8 TO NULL in sls_ship_dt + sls_due_dt
	-- CHANGING 0 OR LEN != 8 TO NULL in sls_order_dt + same on sls_ship_dt, sls_due_dt
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
		ELSE CAST( CAST( sls_order_dt AS VARCHAR ) AS DATE)
	END AS sls_order_dt,
	CASE 
		WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
		ELSE CAST( CAST( sls_ship_dt AS VARCHAR ) AS DATE)
	END AS sls_ship_dt,
	CASE 
		WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
		ELSE CAST( CAST( sls_due_dt AS VARCHAR ) AS DATE)
	END AS sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details


-- Improve the quality of the sales data relation
	-- Focusing on a few columns
SELECT
    sls_ord_num,
    sls_quantity,
	sls_sales AS old_sls_sales,
	sls_price AS old_sls_price,
		-- Fix Sales (Handle Negatives, NULLs, Zeros)
    CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) -- Derive from Qty * Price
        ELSE sls_sales 
    END AS sls_sales,
		-- Fix Price (Handle Negatives, then NULLs/Zeros)
    CASE 
        WHEN sls_price < 0 THEN ABS(sls_price)  -- Convert negative to positive
        WHEN sls_price IS NULL OR sls_price = 0 THEN sls_sales / NULLIF(sls_quantity, 0) -- Derive from Sales/Qty
        ELSE sls_price 
    END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
   OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
   OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

	-- === Included into Whole DATA ===
	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
	CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
		ELSE CAST( CAST( sls_order_dt AS VARCHAR ) AS DATE)
	END AS sls_order_dt,
	CASE 
		WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
		ELSE CAST( CAST( sls_ship_dt AS VARCHAR ) AS DATE)
	END AS sls_ship_dt,
	CASE 
		WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
		ELSE CAST( CAST( sls_due_dt AS VARCHAR ) AS DATE)
	END AS sls_due_dt,
    CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) -- Derive from Qty * Price
        ELSE sls_sales 
    END AS sls_sales,
	sls_quantity,
    CASE 
        WHEN sls_price < 0 THEN ABS(sls_price)  -- Convert negative to positive
        WHEN sls_price IS NULL OR sls_price = 0 THEN sls_sales / NULLIF(sls_quantity, 0) -- Derive from Sales/Qty
        ELSE sls_price 
    END AS sls_price
	FROM bronze.crm_sales_details;

-- === INSERT DATA INTO THE SILVER LAYER

INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
  CASE 
    WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
    ELSE CAST( CAST( sls_order_dt AS VARCHAR ) AS DATE)
  END AS sls_order_dt,
  CASE 
    WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
    ELSE CAST( CAST( sls_ship_dt AS VARCHAR ) AS DATE)
  END AS sls_ship_dt,
  CASE 
    WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
    ELSE CAST( CAST( sls_due_dt AS VARCHAR ) AS DATE)
  END AS sls_due_dt,
  CASE 
      WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) -- Derive from Qty * Price
      ELSE sls_sales 
  END AS sls_sales,
  sls_quantity,
  CASE 
      WHEN sls_price < 0 THEN ABS(sls_price)  -- Convert negative to positive
      WHEN sls_price IS NULL OR sls_price = 0 THEN sls_sales / NULLIF(sls_quantity, 0) -- Derive from Sales/Qty
      ELSE sls_price 
  END AS sls_price
FROM bronze.crm_sales_details;
