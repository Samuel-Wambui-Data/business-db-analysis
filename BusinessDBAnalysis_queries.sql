-- ==================================
-- SECTION 1: BASIC DATA EXPLORATION
-- ==================================

-- Q1: Show all customers from Kenya
SELECT *
FROM customers
WHERE country = 'Kenya';

-- Q2: List all products in Electronics category
SELECT *
FROM products
WHERE category = 'Electronics';

-- Q3: Display all orders made in January 2024
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';

-- Q4: Count ttotal number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q5: Find total number of products
SELECT COUNT(*) AS total_products
FROM products;


-- ===================================
-- SECTION 2: AGGREGATIONS & METRICS
-- ===================================

-- Q6: Calculate total revenue generated
SELECT SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id;

-- Q7: Find average product price
SELECT AVG(price) AS average_price
FROM products;

-- Q8: Count orders made by each customer
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;

-- Q9: Calculate total quantity of products sold
SELECT SUM(quantity) AS total_products_sold
FROM order_details;

-- Q10: Find category with highest number of products
SELECT category, COUNT(*) AS total_products
FROM products
GROUP BY category
ORDER BY total_products DESC;


-- ==================================
-- SECTION 3: JOINS & RELATIONSHPS
-- ==================================

-- Q11: show all orders with customer names
SELECT o.order_id, o.order_date, c.first_name, c.last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Q12: Display products purchased in each order
SELECT o.order_id, p.product_name, od.quantity
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;

-- Q13: Calculate total spending per customer
SELECT c.first_name,
       SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.first_name;

-- Q14: Show order details including product name, quantity and price
SELECT o.order_id,
       p.product_name,
       od.quantity,
       p.price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;

-- Q15: Find customers who never placed an order
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- ======================================
-- SECTION 4: BUSINESS INSIGHTS
-- ======================================

-- Q16: Identify top 3 customers by spending
SELECT c.first_name,
       SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.first_name
ORDER BY total_spent DESC
LIMIT 3;

-- Q17: Find top 5 best-selling products
SELECT p.product_name,
       SUM(od.quantity) AS total_sold
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- Q18: Determine product generating highest revenue
SELECT p.product_name,
       SUM(p.price * od.quantity) AS revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 1;

-- Q19: Calculate revenue by category
SELECT p.category,
       SUM(p.price * od.quantity) AS revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Q20: Find country generating highest revenue
SELECT c.country,
       SUM(p.price * od.quantity) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.country
ORDER BY revenue DESC;


-- =====================================
-- SECTION 5: ADVANCED SQL
-- =====================================

-- Q21: Rank customers by spending
SELECT c.first_name,
       SUM(p.price * od.quantity) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.price * od.quantity) DESC) AS customer_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.first_name;

-- Q22: Analyze monthly revenue trends
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(p.price * od.quantity) AS revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Q23: Identify repeat custoomers
SELECT c.first_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name
HAVING COUNT(o.order_id) > 1;

-- Q24: Calculate average order values
SELECT AVG(order_total) AS average_order_value
FROM (
    SELECT o.order_id,
           SUM(p.price * od.quantity) AS order_total
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) t;

-- Q25: Find most popular product per category
SELECT category,
       product_name,
       total_sold
FROM (
    SELECT p.category,
           p.product_name,
           SUM(od.quantity) AS total_sold,
           RANK() OVER (
               PARTITION BY p.category
               ORDER BY SUM(od.quantity) DESC
           ) AS ranking
    FROM products p
    JOIN order_details od ON p.product_id = od.product_id
    GROUP BY p.category, p.product_name
) ranked
WHERE ranking = 1;