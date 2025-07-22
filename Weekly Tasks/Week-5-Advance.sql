/* 1) Calculate month-over-month revenue growth for the entire year.
Display the results as a list of months, their revenue, and the growth percentage. */
WITH MonthlyRevenue AS (
    SELECT 
        FORMAT(date, 'yyyy-MM') month, SUM(quantity * price) revenue
    FROM 
        orders od
    JOIN 
        order_details ord ON od.order_id = ord.order_id
    JOIN 
        pizzas piz ON ord.pizza_id = piz.pizza_id
    GROUP BY 
        FORMAT(date, 'yyyy-MM')
)
SELECT 
    month, revenue, LAG(revenue) OVER (ORDER BY month) AS previous_revenue,
    CASE 
        WHEN LAG(revenue) OVER (ORDER BY month) IS NULL THEN NULL
        ELSE ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0) / LAG(revenue) OVER (ORDER BY month), 2)
    END AS growth_percentage
FROM 
    MonthlyRevenue


/* 2) List all orders placed during breakfast hours (9:00 AM–11:00 AM) or afternoon lull hours (2:00 PM–5:00 PM), 
including the order ID, date, time, and name of the pizza ordered.*/
SELECT 
    od.order_id, date, time, name pizza_name
FROM 
    orders od
JOIN 
    order_details ord ON od.order_id = ord.order_id
JOIN 
    pizzas piz ON ord.pizza_id = piz.pizza_id
JOIN 
    pizza_types pit ON piz.pizza_type_id = pit.pizza_type_id
WHERE 
    (CAST(time AS TIME) BETWEEN '09:00:00' AND '11:00:00')
    OR 
    (CAST(time AS TIME) BETWEEN '14:00:00' AND '17:00:00')
ORDER BY 
    date, time

-- 3) Find all pizzas where the ingredients field contains both "Pepperoni" and "Onions" but does not include "Mushrooms".
SELECT 
pizza_type_id, name, ingredients
FROM 
pizza_types
WHERE 
  ingredients LIKE '%Pepperoni%'
  AND ingredients LIKE '%Onions%'
  AND ingredients NOT LIKE '%Mushrooms%'


/* 4) Use ROW_NUMBER to rank orders by quantity growth month-over-month. 
Focus only on orders where the quantity increased compared to the previous month. */
WITH MonthlyOrderQuantity AS (
    SELECT
        od.order_id, DATEPART(YEAR, date) order_year, DATEPART(MONTH, date) order_month, SUM(quantity) total_quantity
    FROM 
        orders od
    JOIN 
        order_details ord ON od.order_id = ord.order_id
    GROUP BY 
        od.order_id, DATEPART(YEAR, date), DATEPART(MONTH, date)
),
QuantityWithLag AS (
    SELECT 
        *, LAG(total_quantity) OVER (PARTITION BY order_year ORDER BY order_month) prev_month_quantity
    FROM 
    MonthlyOrderQuantity
),
IncreasedOrders AS (
    SELECT 
        *
    FROM 
        QuantityWithLag
    WHERE 
        total_quantity > ISNULL(prev_month_quantity, 0)
),
RankedOrders AS (
    SELECT 
        *, ROW_NUMBER() OVER (PARTITION BY order_year ORDER BY (total_quantity - prev_month_quantity) DESC) rank
    FROM 
        IncreasedOrders
)
SELECT *
FROM  RankedOrders


-- 5) Create an index on the date column in the orders table and explain why it improves performance when filtering by date.

CREATE INDEX idx_orders_date ON orders(date)

/* Creating an index on the date column improves performance by allowing SQL Server to quickly locate relevant rows without scanning the entire table. 
This speeds up queries that filter by date or date ranges and reduces the amount of data the system needs to read, 
especially in large datasets. */

-- 6) What is the average revenue per order for customers who placed more than 5 orders?
WITH Order_Revenue AS (
    SELECT 
        od.order_id, SUM(ord.quantity * piz.price) total_revenue
    FROM 
        orders od
    JOIN 
        order_details ord ON od.order_id = ord.order_id
    JOIN 
        pizzas piz ON ord.pizza_id = piz.pizza_id
    GROUP BY 
        od.order_id
),
Customer_Order_Count AS (
    SELECT 
        order_id
    FROM 
        orders
    GROUP BY 
        order_id
    HAVING 
        COUNT(order_id) > 5
)
SELECT 
    AVG(orv.total_revenue) AS avg_revenue_per_order
FROM 
    Order_Revenue orv
JOIN 
    Customer_Order_Count coc ON orv.order_id = coc.order_id


-- 7) Which pizza size has the highest average price per unit sold?
SELECT TOP 1 
    piz.size, ROUND(SUM(ord.quantity * piz.price) * 1.0 / SUM(ord.quantity), 2) avg_price_per_unit
FROM 
    order_details ord
JOIN 
    pizzas piz ON ord.pizza_id = piz.pizza_id
GROUP BY 
    piz.size
ORDER BY 
    avg_price_per_unit DESC


-- 8) How many unique ingredients are used across all pizzas?
WITH IngredientsSplit AS (
    SELECT 
        TRIM(value) ingredient
    FROM 
        pizza_types CROSS APPLY STRING_SPLIT(ingredients, ',')
)
SELECT 
    COUNT(DISTINCT ingredient) unique_ingredient_count
FROM 
    IngredientsSplit



