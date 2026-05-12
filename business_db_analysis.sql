CREATE DATABASE business_db;
USE business_db;

-- 
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
country VARCHAR(50)
);
CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2)
);
CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_details (
order_detail_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (order_id) REFERENCES
orders(order_id),
FOREIGN KEY (product_id) REFERENCES
products(product_id)
);

--
INSERT INTO customers VALUES
(1,'John','Doe','john@example.com','USA'),
(2,'Jane','Smith','jane@example.com','UK'),
(3,'Samuel','Wambui','sam@example.com','Kenya'),
(4,'Ali','Hassan','ali@example.com','UAE'),
(5,'Maria','Garcia','maria@example.com','Spain');

INSERT INTO products VALUES
(1,'Laptop','Electronics',800),
(2,'Phone','Electronics',500),
(3,'Headphones','Electronics',100),
(4,'Desk','Furniture',200),
(5,'Chair','Furniture',120);

INSERT INTO orders VALUES
(1,3,'2024-01-01'),
(2,1,'2024-01-02'),
(3,2,'2024-01-03'),
(4,3,'2024-01-05'),
(5,5,'2024-01-06');

INSERT INTO order_details VALUES
(1,1,1,2),
(2,1,3,1),
(3,2,2,1),
(4,3,5,2),
(5,4,4,1);
