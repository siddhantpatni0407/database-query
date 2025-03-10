-- Insert into Departments
INSERT INTO departments (department_name) VALUES
('HR'), ('Finance'), ('IT'), ('Sales');

-- Insert into Employees
INSERT INTO employees (name, department_id, salary) VALUES
('Alice', 1, 60000),
('Bob', 2, 70000),
('Charlie', 3, 80000),
('David', 4, 90000),
('Emma', NULL, 75000); -- No department

-- Insert into Customers
INSERT INTO customers (name, email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Michael Brown', 'michael@example.com');

-- Insert into Orders
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-02-15'),
(2, '2024-02-16'),
(3, '2024-02-17');

-- Insert into Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 101, 2, 50.00),
(1, 102, 1, 30.00),
(2, 103, 3, 20.00),
(3, 104, 1, 15.00);

-- Insert into Sales
-- Insert sample sales data
INSERT INTO sales (employee_id, sale_amount, sale_date) VALUES
(1, 1500.00, '2024-02-20'),
(2, 2300.50, '2024-02-21'),
(3, 1800.75, '2024-02-22'),
(1, 1200.25, '2024-02-23'),
(2, 2500.00, '2024-02-24'),
(3, 3000.00, '2024-02-25'),
(4, 500.00, '2024-02-26'),
(5, 750.00, '2024-02-27'),
(1, 2200.00, '2024-02-28'),
(2, 1750.00, '2024-02-29');