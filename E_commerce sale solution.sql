select * from customers
select * from orders
select * from payments
select * from products
select * from shipping

-- Q1 Find the total number of unique customers in the Orders table.

select * from orders

select count(distinct customer_id) as unique_customers from orders

-- Q2 Calculate the total revenue generated from all orders in the Orders table.

select sum(total_price) as total_revenue
from orders

-- Q3 Find the average order value (Total_Price) for orders placed in the month of March 2025.

select avg(total_price) as total_avg
from orders
where order_date between '2025-03-01' and '2025-03-31'

-- Q4 Find the total quantity of products sold for each product in the Order_Items table.

select product_id, sum(quantity) as total_quantity
from orders
group by product_id

-- Q5 Find the maximum order total price (Total_Price) placed by any customer.

select max(total_price) as total_price
from orders

select * from customers
select * from orders
select * from payments
select * from products
select * from shipping

-- Q6 Find the total amount spent by each customer.

select customer_name, sum(total_price) as total_amount
from orders as o
join customers as c
on o.customer_id = c.customer_id
group by customer_name

-- Q7 List all orders with customer name and product name where the order quantity is greater than 5.

select  customer_name, product_name, sum(quantity) as total_quantity
from customers as c
join orders as o
on c.customer_id = o.customer_id
join products as p
on p.product_id = o.product_id
group by customer_name, product_name
having sum(quantity) >= 5

-- Q8 Find the total number of orders placed for each product.

select product_name, count(*) as total_orders
from products as p
join orders as o
on p.product_id = o.product_id
group by product_name

-- Q9 Find the total quantity of each product ordered (across all customers).

select product_name, sum(quantity) as total_quantity
from orders as o
join products as p
on o.product_id = p.product_id
group by product_name

-- Q10 Which payment mode has generated the highest total payment amount?

select * from payments
select * from orders

select payment_method, sum(total_price) as total_amount
from payments as p
join orders as o
on p.order_id = o.order_id
group by payment_method
order by total_amount desc

-- Q11 How many orders have been delivered, cancelled, and pending? Provide counts for each status.

select * from shipping

select delivery_status, count(*) as total_orders
from shipping
group by delivery_status
order by total_orders desc

-- Q12 Which product has the highest total quantity sold? Show product name and total quantity.

select * from orders
select * from products

select product_name, sum(quantity) as total_quantity
from orders as o
join products as p
on o.product_id = p.product_id
group by product_name
order by total_quantity desc
limit 5

-- Window function
-- Q1 Find each customer’s total spending, and also show their rank based on spending (highest spender gets rank 1).
--- Show customer name, total spent, and rank.

select customer_name,
sum(total_price) as total_spent,
rank() over (order by sum(total_price) desc)as rank
from orders as o
join customers as c
on o.customer_id = c.customer_id
group by customer_name

-- Method Second Using CTE Function

WITH customer_totals AS (
    SELECT 
        c.customer_name,
        SUM(o.total_price) AS total_spent
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_name
)
SELECT 
    customer_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS rank
FROM customer_totals;

select * from customers
select * from orders
select * from payments
select * from products
select * from shipping

-- Q2 Find the total amount spent by each customer on all their orders, and show the running total (cumulative total) of order prices 
--    for each customer, ordered by the order date.

select c.customer_id, c.customer_name,
sum(o.total_price) over (partition by c.customer_id order by o.order_date) as total_running
from orders as o
join customers as c
on o.customer_id = c.customer_id
order by c.customer_id, o.order_id

-- Q3 Write a query to display the following:

--   For each product (product_name),

--   Calculate the total quantity sold for each product (using sum),

--   Then show the row number for each product based on total quantity sold in descending order (use row_number).

--   Show the result as: product_name, total_quantity, row_number.

select * from products
select * from orders

select p.product_id, p.product_name,
sum(o.quantity) over (partition by p.product_id) as total_quantity,
row_number() over (order by p.product_name desc) as row_num
from products as p
join orders as o
on p.product_id = o.product_id
order by total_quantity asc, row_num desc