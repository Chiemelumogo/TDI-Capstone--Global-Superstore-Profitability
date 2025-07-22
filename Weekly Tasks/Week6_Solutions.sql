-- 1) List all orders placed on the last day of all months. Show order_id, date, and time sorted chronologically.
SELECT 
	order_id, date, time
FROM 
	orders
WHERE 
	date = EOMONTH(date)
ORDER BY 
	date, time


/* 2) Show the 3 most expensive pizzas (by individual price) that include both "Chicken" and "Mushrooms" in their ingredients. 
Display pizza_id, name, and price.*/
SELECT TOP 3
    piz.pizza_id, name,	price
FROM 
	pizzas AS piz
JOIN 
	pizza_types AS pit ON piz.pizza_type_id = pit.pizza_type_id
WHERE 
    ingredients LIKE '%Chicken%' 
    AND ingredients LIKE '%Mushrooms%'
ORDER BY 
	price DESC


/* 3) Calculate the running total revenue per day for all orders, but exclude Sundays. 
Display date, Daily Revenue, and Cumulative Revenue sorted by date. */
SELECT 
    date,
    CAST(SUM(quantity * price) AS DECIMAL(10,2)) daily_revenue,
    CAST(SUM(SUM(quantity * price)) OVER (ORDER BY date) AS DECIMAL(10,2)) cumulative_revenue
FROM 
	orders od
JOIN 
	order_details ord ON od.order_id = ord.order_id
JOIN 
	pizzas piz ON ord.pizza_id = piz.pizza_id
WHERE 
	DATENAME(WEEKDAY, date) != 'Sunday'
GROUP BY 
	date
ORDER BY 
	date


/* 4) For orders containing at least 4 different pizza types, show order_id, count of unique categories in the order, 
and a comma-separated list of pizza names.*/
SELECT 
    od.order_id,
    COUNT(DISTINCT category) unique_categories,
    STRING_AGG(name, ', ') pizza_names
FROM orders od
JOIN order_details ord ON od.order_id = ord.order_id
JOIN pizzas piz ON ord.pizza_id = piz.pizza_id
JOIN pizza_types pit ON piz.pizza_type_id = pit.pizza_type_id
GROUP BY od.order_id
HAVING COUNT(DISTINCT pit.pizza_type_id) >= 4

