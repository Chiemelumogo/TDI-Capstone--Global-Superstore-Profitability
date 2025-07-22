/* 1) How many orders were placed each month in 2015? Return the results as a list that includes the month number, 
the month name,and the total number of orders. Sort the results by month number. */

SELECT
	MONTH(date) Month_Number, DATENAME(MONTH, date) Month, COUNT(order_id)
FROM
	orders
GROUP BY 
	MONTH(date), DATENAME(MONTH, date)
ORDER BY 
	Month_Number



/* 2) Concatenate the name and category from the pizza_types table into a single column in the format "Name (Category)". */

SELECT
	CONCAT(name, ' ', '(', category, ')') Name_Category
FROM 
	pizza_types



/* 3) List all orders placed between 11:00 AM and 3:00 PM in February, including the pizza name, quantity ordered, date, 
and time of the order */

SELECT 
	name, quantity, date, time
FROM 
	orders od
JOIN
	order_details ord ON od.order_id = ord.order_id
JOIN
	pizzas piz ON piz.pizza_id = ord.pizza_id
JOIN 
	pizza_types pit ON pit.pizza_type_id = piz.pizza_type_id
WHERE 
	MONTH(date) = 2 
	AND time BETWEEN '11:00:00' AND '15:00:00'
ORDER BY
	date, time



/* 4) List all pizzas with their type, size, name, category, and price where the price is higher than 
the average price of all pizzas in the dataset. */

SELECT 
	name Pizza_Name, size, category, ROUND(price, 2) Price
FROM 
	pizza_types pit 
JOIN 
	pizzas piz ON pit.pizza_type_id = piz.pizza_type_id
WHERE 
	Price > (SELECT AVG(price) FROM pizzas)




/* 5) List the top 5 orders where the total quantity ordered is greater than the average quantity per order. 
Rank in descending order.*/

SELECT TOP 5
    order_id,
    SUM(quantity) total_quantity
FROM 
    order_details
GROUP BY 
    order_id
HAVING 
    SUM(quantity) > (SELECT AVG(total_qty) 
					FROM (SELECT SUM(quantity) total_qty FROM order_details 
					GROUP BY order_id) avg_table)
ORDER BY 
    total_quantity DESC



/* 6) List the pizza_type_id, name (from pizzas table), and a human-readable size_category (e.g., 'Small', 'Medium') 
for all pizzas in the pizzas table. */

SELECT
	pit.pizza_type_id, name, 
	CASE
		WHEN size = 'L' THEN 'Large'
		WHEN size = 'M' THEN 'Medium'
		ELSE 'Small' END Size
FROM
	pizzas piz
JOIN 
	pizza_types pit ON pit.pizza_type_id = piz.pizza_type_id



/* 7) List the order_id, pizza_type_id, size, total revenue, and a value_label ('High Value' or 'Standard') for all orders. 
Calculate revenue using quantity and price. → revenue above $50 is High value. */
	
SELECT
	Order_id, pizza_type_id, size, SUM(price * quantity) total_revenue,
	CASE
		WHEN SUM(price * quantity) > 50 THEN 'High Value'
		ELSE 'Standard' END value_label
FROM
	order_details ord
JOIN 
	pizzas piz ON piz.pizza_id = ord.pizza_id
GROUP BY
	Order_id, pizza_type_id, size



/* 8) Use a CTE to calculate the total revenue per pizza type and sort by the total revenue. */

WITH PizzaRevenue AS
    (SELECT 
        pit.pizza_type_id, name pizza_name, SUM(quantity * price) total_revenue
    FROM 
        order_details ord
    JOIN 
        pizzas piz ON ord.pizza_id = piz.pizza_id
    JOIN 
        pizza_types pit ON piz.pizza_type_id = pit.pizza_type_id
    GROUP BY 
        pit.pizza_type_id, name)
SELECT 
    pizza_type_id,
    pizza_name,
    total_revenue
FROM 
    PizzaRevenue
ORDER BY 
    total_revenue DESC



/* 9) Why is a JOIN necessary to analyze the total revenue per pizza category? Which tables would you join, and why? */

/* A JOIN is necessary to analyze total revenue per pizza category because the relevant data needed for the calculation 
is spread across multiple related tables. Tables to joins are
- order_details: Contains quantity and pizza_id.
- pizzas: Contains pizza_id and price.
- pizza_types: Contains pizza_type_id and category. */



/* 10) Suppose you want to find pizzas that have sold a total of over 100 units across all orders. 
Would you use GROUP BY with HAVING or with WHERE to solve this? What is the step-by-step logic behind this approach */

/* To find pizzas that have sold over 100 units across all orders, i will use GROUP BY with HAVING.
Here’s why and the step-by-step logic: 
1) Select the columns and the table needed
2) Use an aggregate function like SUM(quantity) to get total sales.
3) Group the data by pizza_id to calculate the total quantity sold per pizza.
4) Use HAVING to filter the groups where the total is more than 100. */

SELECT 
	pizza_id, SUM(quantity) total_units
FROM 
	order_details
GROUP BY 
	pizza_id
HAVING 
	SUM(quantity) > 100



/* 11) Using DATEPART and CAST, analyze peak order hours using the time field in the orders table. */

SELECT 
	DATEPART(HOUR, CAST(time AS TIME)) AS order_hour, COUNT(*) AS total_orders
FROM 
	orders
GROUP BY 
	DATEPART(HOUR, CAST(time AS TIME))
ORDER BY 
	total_orders DESC

	

/* 12) In the pizza_types.ingredients field, there are values that are separated by a comma. 
Write down the full query to return only pizzas that contain Mushrooms */

SELECT 
	name
FROM
	pizza_types
WHERE
	ingredients LIKE '%Mushrooms%'


