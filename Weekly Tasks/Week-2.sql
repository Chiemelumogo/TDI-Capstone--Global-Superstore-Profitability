-- 1) Retrieve all columns from the orders table and sort the results by date in ascending order.
	Select *
	From Orders
	Order by date


-- 2) Find all orders placed on or before June 30.
	select *
	From orders
	Where date <= '2015-06-30'


-- 3) Identify all orders where the time is between 3PM and 7PM
	Select *
	From orders
	Where time between '15:00:00' and '19:00:00'


-- 4) Find all rows in the order_details table where the quantity is greater than 2.
	Select *
	From order_details
	Where quantity > 2

-- 5) Sort the order_details table by quantity in descending order and return the top 10 rows.
	Select Top 10 *
	From order_details
	Order by quantity desc

-- 6) Calculate the total quantity ordered for each order_id and return the results sorted by total quantity in descending order.
	Select order_id, Sum(quantity) Total_Quantity
	From order_details
	group by order_id
	Order by Total_Quantity Desc


-- 7) Find pizzas that have been ordered more than 10 times in total by grouping the orders by pizza_id.
	Select Pizza_id, count(pizza_id) No_of_orders
	From order_details
	group by pizza_id
	Order by No_of_orders desc


-- 8) Compute the average price for each pizza size (size) and return the results.
	Select size, round(Avg(price), 2) Average_Price
	From pizzas
	Group by size
	Order by Average_Price


-- 9) Join the orders and order_details tables to retrieve the order_id, date,time, pizza_id, and quantity for all orders.
	Select orders.order_id as order_id, date, time, pizza_id, quantity
	From orders
	join order_details
	on orders.order_id = order_details.order_id


-- 10) Join the pizzas and pizza_types tables to list the name and category of each pizza.
	select name, category
	From pizza_types
	join pizzas
	on pizza_types.pizza_type_id = pizzas.pizza_type_id

-- 11) Identify all orders placed during lunch hours on any date.
	select orders.order_id as order_id, pizza_id, quantity
	from orders
	join order_details
	on orders.order_id = order_details.order_id
	Where time between '12:00:00' and '14:59:59'
	order by quantity desc


-- 12) Group the pizzas by size and calculate the total revenue (quantity × price) generated for each size.
	Select size, Round(sum(quantity * price), 2) as Total_revenue
	From pizzas
	join order_details
	on pizzas.pizza_id = order_details.pizza_id
	Group by size
	Order by Total_revenue desc


-- 13) Determine the minimum and maximum price for each pizza size (size)in a single query.
	Select size, min(price) Min_Price, max(price) Max_Price
	from pizzas
	group by size


-- 14) Sort the order_details table by order_id and then by quantity in descending order, and return the first 10 rows.
	Select Top 10 *
	From order_details
	Order by order_id, quantity desc


/* 15) Retrieve pizza_id, count the number of sales, and calculate the total revenue for each pizza. Include only pizzas with more than 20 sales,
		and sort the results by total revenue in descending order. */
	Select pizzas.pizza_id, name, sum(quantity) Quantity_sold, Round(sum(quantity*price), 2) Total_Revenue
	from pizzas
	join order_details
	on pizzas.pizza_id = order_details.pizza_id
	join pizza_types 
	on pizza_types.pizza_type_id = pizzas.pizza_type_id
	Group by pizzas.pizza_id, name
	Having sum(quantity) > 20
	order by Total_Revenue desc
	

	


