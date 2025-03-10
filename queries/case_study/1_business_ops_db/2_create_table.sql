-- Create Employee Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE DEFAULT CURRENT_DATE
);

-- Create Sales Table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    sale_amount DECIMAL(10,2),
    sale_date DATE DEFAULT CURRENT_DATE
);

-- Create Department Table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL
);

-- Create Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100)
);

-- Create Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Order_Items Table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price DECIMAL(10,2)
);

-- Create Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255) UNIQUE,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Create User Logins Table
CREATE TABLE user_logins (
    login_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES customers(customer_id),
    login_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

