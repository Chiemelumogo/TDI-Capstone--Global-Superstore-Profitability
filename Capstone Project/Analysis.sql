-- Total Profit, Cost and Profit
SELECT
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Cost), 2) AS Total_Cost,
	ROUND(SUM(Profit), 2) AS Total_Profit,
	SUM(quantity) AS Total_Quantity,
	COUNT(DISTINCT Customer_id) AS Total_Customers
FROM 
	Global_Superstore


-- OBJECTIVE - Evaluate Product and Category Performance
-- Which product categories and subcategories contribute most to profit and revenue?
--Category
SELECT
	category,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Cost), 2) AS Total_Cost,
	ROUND(SUM(Profit), 2) AS Total_Profit,
	SUM(quantity) AS Total_Quantity
FROM 
	Global_Superstore GS
JOIN 
	Products P ON P.product_id = GS.Product_ID
GROUP BY
	category
ORDER BY
	Total_Profit DESC, Total_Quantity DESC


--Category with Sub_category
SELECT
	category,
	sub_category,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Cost), 2) AS Total_Cost,
	ROUND(SUM(Profit), 2) AS Total_Profit,
	SUM(quantity) AS Total_Quantity
FROM 
	Global_Superstore GS
JOIN 
	Products P ON P.product_id = GS.Product_ID
GROUP BY
	category, sub_category
ORDER BY
	Total_Profit DESC, Total_Quantity DESC


-- Top 25 and Non-Profit Products
-- Top 25
SELECT TOP 25
	Product_name,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Cost), 2) AS Total_Cost,
	ROUND(SUM(Profit), 2) AS Total_Profit,
	SUM(quantity) AS Total_Quantity
FROM 
	Global_Superstore GS
JOIN
	Products P ON P.product_id = GS.Product_ID
GROUP BY
	product_name
ORDER BY
	Total_Profit DESC, Total_Quantity DESC


-- Non-Profit products
SELECT
	Product_name,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Cost), 2) AS Total_Cost,
	ROUND(SUM(Profit), 2) AS Total_Profit,
	SUM(quantity) AS Total_Quantity
FROM 
	Global_Superstore GS
JOIN
	Products P ON P.product_id = GS.Product_ID
GROUP BY
	product_name
HAVING 
	ROUND(SUM(Profit), 2) < 0
ORDER BY
	Total_Profit, Total_Quantity


	-- Products with High sales but low profit
SELECT TOP 25
	Product_name,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM 
	Global_Superstore GS
JOIN
	Products P ON P.product_id = GS.Product_ID
GROUP BY
	product_name
ORDER BY
	Total_Sales DESC, Total_Profit


-- Flag products with high sales but low profit
WITH ProductPerformance AS (
    SELECT 
        p.product_name,
        SUM(sales) AS Total_sales,
        SUM(profit) AS Total_profit
    FROM 
        Global_Superstore gs
    JOIN 
        Products p ON gs.product_id = p.product_id
    GROUP BY 
        product_name
)
SELECT 
    *,
    CASE 
        WHEN total_sales > (
            SELECT AVG(total_sales) FROM (
                SELECT SUM(sales) AS total_sales
                FROM Global_Superstore
                GROUP BY product_id
            ) AS SalesAvg
        )
        AND total_profit < 0 THEN 'High Sales, Low Profit'
        ELSE 'Normal'
    END AS Flag
FROM ProductPerformance
ORDER BY total_sales DESC




-- OBJECTIVE - Understand Customer Behavior
-- Customer Segment total revenue and Profit
SELECT 
	Segment,
	ROUND(SUM(Sales), 2) AS Total_Revenue,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM
	Global_Superstore GS
JOIN
	Customers C ON gs.customer_id = c.customer_id
GROUP BY
	Segment
ORDER BY
	Total_Profit DESC, Total_Revenue DESC


-- Top 25 most Profitable Customer
SELECT TOP 25
	Customer_name,
	ROUND(SUM(Sales), 2) AS Total_Revenue,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM
	Global_Superstore GS
JOIN
	Customers C ON gs.Customer_ID = c.customer_id
GROUP BY
	customer_name
ORDER BY
	Total_Profit DESC, Total_Revenue DESC

-- Differences in buying behavior between customer segments
SELECT 
    c.segment,
    COUNT(DISTINCT gs.customer_id) AS Total_customers,
    COUNT(DISTINCT order_id) AS Total_Orders,
    ROUND(SUM(sales), 2) AS Total_Sales,
    ROUND(AVG(sales), 2) AS Avg_Order_Value,
    ROUND(SUM(quantity), 2) AS Total_Quantity,
    ROUND(AVG(quantity), 2) AS Avg_Quantity_per_Order,
    ROUND(SUM(profit), 2) AS Total_Profit,
    ROUND(AVG(profit), 2) AS Avg_Profit_per_Order
 FROM 
    Global_Superstore gs
JOIN 
    Customers c ON gs.customer_id = c.customer_id
GROUP BY 
    c.segment
ORDER BY 
    total_sales DESC



-- OBJECTIVE: Time-Based/Seasonal Trends
-- Year to Year sales and Profit Trends
SELECT
	YEAR(order_date) AS Order_Year,
	ROUND(SUM(sales), 2) AS Total_Sales,
    ROUND(SUM(profit), 2) AS Total_Profit,
	COUNT(order_id) AS Total_Orders
FROM
	Global_Superstore
GROUP BY
	YEAR(order_date)
ORDER BY
	YEAR(order_date)



-- Month to Month sales and profit Trends
SELECT
	MONTH(order_date) AS Order_Month, 
	DATENAME(MONTH, Order_Date) AS Month_Name,
	ROUND(SUM(sales), 2) AS Total_Sales,
    ROUND(SUM(profit), 2) AS Total_Profit,
	COUNT(order_id) AS Total_Orders
FROM
	Global_Superstore
GROUP BY
	MONTH(order_date), DATENAME(MONTH, Order_Date)
ORDER BY
	Order_Month



-- Which day of the week has the highest order?
SELECT 
    DATENAME(WEEKDAY, order_date) AS Day_of_Week,
    COUNT(order_id) AS Total_Orders,
    ROUND(SUM(sales), 2) AS Total_Sales,
    ROUND(SUM(profit), 2) AS Total_Profit
FROM Global_Superstore
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY 
    CASE DATENAME(WEEKDAY, order_date)
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END


-- OBJECTIVE - Location-Based Trends
-- Most Profitable Countries
SELECT TOP 25
	Country,
	ROUND(SUM(sales), 2) AS Total_sales,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM
	Global_Superstore
GROUP BY
	Country
ORDER BY
	Total_Profit DESC

-- Countries with Negative Profit
SELECT
	Country,
	ROUND(SUM(sales), 2) AS Total_sales,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM
	Global_Superstore
GROUP BY
	Country
HAVING
	SUM(Profit) < 0
ORDER BY
	Total_Profit
