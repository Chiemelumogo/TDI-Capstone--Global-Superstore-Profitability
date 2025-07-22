-- View our table and the number of rows 
SELECT *
FROM Global_Superstore


-- Number of rows
SELECT COUNT(*)
FROM Global_Superstore


-- We create our Customers and Products Table from the Global_Superstore table
-- Creation of Customers table
CREATE TABLE Customers
    (
    customer_id NVARCHAR(50) Primary Key,
    customer_name NVARCHAR(100),
    segment NVARCHAR(50)
    )


-- Inserting of our customer data from the Global_Superstore table to Customers table
INSERT INTO 
    Customers (customer_id, customer_name, segment)
SELECT DISTINCT
    customer_id,
    customer_name,
    segment
FROM 
    Global_Superstore


-- Count the total number of customers we have
SELECT COUNT(*) 
FROM Customers


--  Creation of Products table
CREATE TABLE Products 
(
    product_id NVARCHAR(50) PRIMARY KEY,
    product_name NVARCHAR(255),
    category NVARCHAR(100),
    sub_category NVARCHAR(100)
)


-- Inserting of our Product data from our Global_Superstore table to Products table
INSERT INTO 
    Products (product_id, product_name, category, sub_category)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM 
    Global_Superstore


-- To check Product_id with more than one product_name assigned to it
 SELECT 
    product_id,
    COUNT(DISTINCT product_name) AS product_name_count
FROM 
    Global_superstore
GROUP BY 
    product_id
HAVING 
    COUNT(DISTINCT product_name) > 1
ORDER BY 
    product_name_count DESC


/* This shows me Product_id with more than one product_name assigned to it, 
number of product_name assigned the said product_id and the product_names assigned to the said product_id */
WITH DistinctProducts AS (
    SELECT 
        DISTINCT product_id, product_name
    FROM 
        Global_Superstore
)
SELECT 
    product_id,
    COUNT(*) AS distinct_product_name_count,
    STRING_AGG(product_name, ', ') AS product_names_list
FROM 
    DistinctProducts
GROUP BY 
    product_id
HAVING 
    COUNT(*) > 1
ORDER BY 
    Product_id


-- Table that reassigns new Product_id for extra product_name on product_id while maintaining the first product_name of the product_id. it also returns the Products_id with one product_name
WITH Duplicates AS (
    SELECT DISTINCT product_id, product_name
    FROM Global_Superstore
),
Ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_name) AS rn
    FROM Duplicates
),
Reassigned AS (
    SELECT 
        product_id,
        product_name,
        CASE 
            WHEN rn = 1 THEN product_id  -- Keep original
            ELSE product_id + '_'+CAST(rn-1 AS VARCHAR)  -- Create new ID for extras
        END AS new_product_id
    FROM Ranked
)
SELECT * FROM Reassigned


-- We applied the ressigned table to update to the Global_superstore
WITH Duplicates AS (
    SELECT DISTINCT product_id, product_name
    FROM Global_Superstore
),
Ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_name) AS rn
    FROM Duplicates
),
Reassigned AS (
    SELECT 
        product_id,
        product_name,
        CASE 
            WHEN rn = 1 THEN product_id  -- Keep original
            ELSE product_id + '_'+CAST(rn-1 AS VARCHAR)  -- Create new ID for extras
        END AS new_product_id
    FROM Ranked
)
UPDATE 
    Global_Superstore
SET 
    Product_ID = R.new_product_id
FROM 
    Global_Superstore GS
JOIN 
    Reassigned r ON GS.Product_ID = R.Product_ID AND GS.Product_Name = R.Product_Name


-- Count number of rows in product table
SELECT  COUNT(*)
FROM Products


-- Backup the Global_Superstore table
SELECT *
INTO Global_Superstore_Backup
FROM Global_Superstore


-- Delete redundant columns due to the creation of customer and product table
ALTER TABLE 
    Global_Superstore
DROP COLUMN 
    customer_name, segment, product_name, category, sub_category


-- DATA CLEANING
-- Check of duplicates
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY row_id ORDER BY row_id) AS rn
    FROM Global_Superstore
)
SELECT * FROM CTE WHERE rn > 1


-- Check for extra spaces
SELECT *
FROM Customers
WHERE customer_name <> LTRIM(RTRIM(customer_name))
OR segment <> LTRIM(RTRIM(segment))
OR customer_id <> LTRIM(RTRIM(customer_id))

SELECT *
FROM Products
WHERE product_id <> LTRIM(RTRIM(product_id))
   OR product_name <> LTRIM(RTRIM(product_name))
   OR category <> LTRIM(RTRIM(category))
   OR sub_category <> LTRIM(RTRIM(sub_category))

SELECT *
FROM Global_Superstore
WHERE city <> LTRIM(RTRIM(city))
   OR country <> LTRIM(RTRIM(country))
   OR market <> LTRIM(RTRIM(market))
   OR order_id <> LTRIM(RTRIM(order_id))
   OR order_priority <> LTRIM(RTRIM(order_priority))
   OR region <> LTRIM(RTRIM(region))
   OR ship_mode <> LTRIM(RTRIM(ship_mode))
   OR state <> LTRIM(RTRIM(state))
   OR customer_id <> LTRIM(RTRIM(customer_id))
   OR product_id <> LTRIM(RTRIM(product_id))
   OR Postal_Code <> LTRIM(RTRIM(Postal_Code))

-- Check for NULLs
SELECT *
FROM Customers
WHERE customer_id IS NULL
   OR customer_name IS NULL
   OR segment IS NULL


SELECT *
FROM Products
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR sub_category IS NULL

SELECT *
FROM Global_Superstore
WHERE city IS NULL
   OR country IS NULL
   OR discount IS NULL
   OR market IS NULL
   OR order_date IS NULL
   OR order_id IS NULL
   OR order_priority IS NULL
   OR profit IS NULL
   OR quantity IS NULL
   OR region IS NULL
   OR row_id IS NULL
   OR sales IS NULL
   OR ship_date IS NULL
   OR ship_mode IS NULL
   OR shipping_cost IS NULL
   OR state IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL
   OR Postal_Code IS NULL


-- Creation of Cost and Profit margin columns
ALTER TABLE 
    Global_Superstore
ADD Cost FLOAT,
    Profit_margin FLOAT

--Inputting Values
UPDATE Global_Superstore
SET 
    Cost = sales - profit,
    Profit_margin = CASE 
                      WHEN sales = 0 THEN NULL
                      ELSE (profit / sales) * 100 
                    END



SELECT *
FROM Global_Superstore

SELECT *
FROM Customers

SELECT *
FROM Products
