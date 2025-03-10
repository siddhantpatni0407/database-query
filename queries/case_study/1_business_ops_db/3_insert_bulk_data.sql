-- ================================
-- STEP 1: Insert Data into Departments Table (8 departments)
-- ================================
INSERT INTO departments (department_name) VALUES
    ('HR'),
    ('Engineering'),
    ('Sales'),
    ('Marketing'),
    ('Finance'),
    ('Customer Support'),
    ('IT'),
    ('Operations');

-- ================================
-- STEP 2: Insert Data into Employees Table (2,000 records with real names)
-- ================================
DO $$ 
DECLARE 
    i INT := 1; 
    first_names TEXT[] := ARRAY['John', 'Emma', 'Michael', 'Sophia', 'David', 'Olivia', 'James', 'Ava', 'Daniel', 'Mia',
                               'Matthew', 'Charlotte', 'Ethan', 'Amelia', 'Joseph', 'Harper', 'Benjamin', 'Evelyn', 
                               'Samuel', 'Abigail', 'Christopher', 'Ella', 'Andrew', 'Scarlett', 'Joshua', 'Grace',
                               'Nathan', 'Lily', 'Ryan', 'Hannah'];
    last_names TEXT[] := ARRAY['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 
                               'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 
                               'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Clark', 
                               'Lewis', 'Walker', 'Hall', 'Allen'];
BEGIN 
    WHILE i <= 2000 LOOP 
        INSERT INTO employees (name, department_id, salary, hire_date) 
        VALUES (
            first_names[1 + (i % array_length(first_names, 1))] || ' ' || 
            last_names[1 + (i % array_length(last_names, 1))], 
            (1 + (i % 8)), 
            (45000 + (i * 10) % 25000), 
            '2015-01-01'::DATE + (i % 2000)
        ); 
        i := i + 1; 
    END LOOP; 
END $$;

-- ================================
-- STEP 3: Insert Data into Products Table (20 products)
-- ================================
INSERT INTO products (product_name, category) VALUES
    ('Laptop', 'Electronics'),
    ('Smartphone', 'Electronics'),
    ('Office Chair', 'Furniture'),
    ('Desk Lamp', 'Furniture'),
    ('Water Bottle', 'Accessories'),
    ('Noise Cancelling Headphones', 'Electronics'),
    ('Coffee Maker', 'Appliances'),
    ('Smartwatch', 'Wearable Tech'),
    ('Gaming Mouse', 'Gaming'),
    ('Portable Hard Drive', 'Storage'),
    ('Monitor', 'Electronics'),
    ('Wireless Keyboard', 'Accessories'),
    ('Standing Desk', 'Furniture'),
    ('Bluetooth Speaker', 'Electronics'),
    ('Microwave Oven', 'Appliances'),
    ('Fitness Tracker', 'Wearable Tech'),
    ('USB-C Hub', 'Accessories'),
    ('External SSD', 'Storage'),
    ('Air Purifier', 'Home Appliances'),
    ('Smart Home Camera', 'Smart Devices');

-- ================================
-- STEP 4: Insert Data into Customers Table (2,000 records with real names)
-- ================================
DO $$ 
DECLARE 
    i INT := 1; 
    first_names TEXT[] := ARRAY['John', 'Emma', 'Michael', 'Sophia', 'David', 'Olivia', 'James', 'Ava', 'Daniel', 'Mia',
                               'Matthew', 'Charlotte', 'Ethan', 'Amelia', 'Joseph', 'Harper', 'Benjamin', 'Evelyn', 
                               'Samuel', 'Abigail', 'Christopher', 'Ella', 'Andrew', 'Scarlett', 'Joshua', 'Grace',
                               'Nathan', 'Lily', 'Ryan', 'Hannah'];
    last_names TEXT[] := ARRAY['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 
                               'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 
                               'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Clark', 
                               'Lewis', 'Walker', 'Hall', 'Allen'];
BEGIN 
    WHILE i <= 2000 LOOP 
        INSERT INTO customers (customer_id, name, email, registration_date) 
        VALUES (
            i,
            first_names[1 + (i % array_length(first_names, 1))] || ' ' || 
            last_names[1 + (i % array_length(last_names, 1))], 
            lower(first_names[1 + (i % array_length(first_names, 1))]) || '.' || 
            lower(last_names[1 + (i % array_length(last_names, 1))]) || i || '@test.com', 
            '2018-01-01'::DATE + (i % 1460)
        ); 
        i := i + 1; 
    END LOOP; 
END $$;

-- ================================
-- STEP 5: Insert Data into Orders Table (2,000 records)
-- ================================
DO $$ 
DECLARE 
    i INT := 1; 
BEGIN 
    WHILE i <= 2000 LOOP 
        INSERT INTO orders (customer_id, order_date) 
        VALUES (
            (1 + (i % 2000)), 
            '2023-06-01'::DATE + (i % 365)
        ); 
        i := i + 1; 
    END LOOP; 
END $$;

-- ================================
-- STEP 6: Insert Data into Order_Items Table (2,000 records)
-- ================================
DO $$ 
DECLARE 
    i INT := 1; 
BEGIN 
    WHILE i <= 2000 LOOP 
        INSERT INTO order_items (order_id, product_id, quantity, price) 
        VALUES (
            (1 + (i % 2000)), 
            (1 + (i % 20)), 
            (1 + (i % 5)), 
            (20 + (i % 800))
        ); 
        i := i + 1; 
    END LOOP; 
END $$;

-- ================================
-- STEP 7: Insert Data into Sales Table (2,000 records)
-- ================================
DO $$ 
DECLARE 
    i INT := 1; 
BEGIN 
    WHILE i <= 2000 LOOP 
        INSERT INTO sales (employee_id, sale_amount, sale_date) 
        VALUES (
            (1 + (i % 2000)), 
            (100 + (i % 1000)), 
            '2023-01-01'::DATE + (i % 365)
        ); 
        i := i + 1; 
    END LOOP; 
END $$;

-- ================================
-- STEP 8: Insert Data into User Logins Table (2,000 records)
-- ================================
DO $$ 
DECLARE 
    i INT := 1; 
BEGIN 
    WHILE i <= 2000 LOOP 
        INSERT INTO user_logins (user_id, login_date) 
        VALUES (
            (1 + (i % 2000)),  -- Ensuring user_id exists within customers table
            '2023-07-01'::TIMESTAMP + (i % 730) * INTERVAL '1 day'
        ); 
        i := i + 1; 
    END LOOP; 
END $$;