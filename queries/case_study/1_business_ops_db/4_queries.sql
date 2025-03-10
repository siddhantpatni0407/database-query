-------------------------------------------------------------------------------
-- Write a query to find the second highest salary in an employee table.
-------------------------------------------------------------------------------

-- ORDER BY salary DESC: Sorts salaries in descending order.
-- LIMIT 1 OFFSET 1: Skips the highest salary and fetches the second highest.

SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 1 
OFFSET 1;

-- First, finds the highest salary.
-- Then finds the max salary less than the highest salary.

SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- DENSE_RANK() ensures if there are duplicate salaries, the correct second highest is retrieved.

SELECT salary 
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) ranked_salaries
WHERE rnk = 2;

/*
Which One to Use?
✅ LIMIT OFFSET 	→ Simple & efficient for small datasets.
✅ MAX() 			→ Works well for unique salaries.
✅ DENSE_RANK() 	→ Best when salaries contain duplicates.
*/

-------------------------------------------------------------------------------
-- Fetch all employees whose names contain the letter "a" exactly twice.
-------------------------------------------------------------------------------

SELECT * 
FROM employees 
WHERE LENGTH(name) - LENGTH(REPLACE(LOWER(name), 'a', '')) = 2;

/*
Explanation:
LENGTH(name) 											→ Gets the total length of the employee's name.
REPLACE(LOWER(name), 'a', '') 							→ Removes all occurrences of "a".
LENGTH(name) - LENGTH(REPLACE(LOWER(name), 'a', ''))	→ Counts how many times "a" appears in the name.
= 2 													→ Filters only names where "a" appears exactly twice.
*/
-------------------------------------------------------------------------------
-- How do you retrieve only duplicate records from a table?
-------------------------------------------------------------------------------
-- 1. Find Duplicate Employees (Based on Name)
SELECT name, COUNT(*)
FROM employees
GROUP BY name
HAVING COUNT(*) > 1;

-- 2. Retrieve All Duplicate Employee Records (Based on Name)
SELECT * 
FROM employees 
WHERE name IN (
    SELECT name 
    FROM employees 
    GROUP BY name 
    HAVING COUNT(*) > 1
);

-- 3. Find Duplicate Customers (Based on Name and Email)
SELECT name, email, COUNT(*)
FROM customers
GROUP BY name, email
HAVING COUNT(*) > 1;

-- 4. Retrieve Orders with Duplicate Customer IDs
SELECT customer_id, COUNT(*)
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 5. Find Duplicate Product Entries (Based on Name)
SELECT product_name, COUNT(*)
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1;

-- 6. Find Complete Duplicate Records in Employees Table

SELECT * 
FROM employees 
WHERE (name, department_id, salary, hire_date) IN (
    SELECT name, department_id, salary, hire_date
    FROM employees
    GROUP BY name, department_id, salary, hire_date
    HAVING COUNT(*) > 1
)
ORDER BY name;

-------------------------------------------------------------------------------
-- Write a query to calculate the running total of sales by date.
-------------------------------------------------------------------------------
SELECT sale_date, 
       sale_amount, 
       SUM(sale_amount) OVER (ORDER BY sale_date) AS running_total
FROM sales;

/*
🔍 Explanation:
SUM(sale_amount) OVER (ORDER BY sale_date) calculates the cumulative sum of sale_amount in the order of sale_date.
This provides a running total for sales on each date.
If multiple sales occur on the same day, they will be included in the running total in the order they appear.
*/

-- Running Total Partitioned by Year (Optional)
SELECT sale_date, 
       sale_amount, 
       SUM(sale_amount) OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY sale_date) AS running_total
FROM sales;

-- Running Total with Ties Handled (Same Date, Order by ID)
SELECT sale_date, 
       sale_amount, 
       SUM(sale_amount) OVER (ORDER BY sale_date, sale_id) AS running_total
FROM sales;

-------------------------------------------------------------------------------
-- Find employees who earn more than the average salary in their department.
-------------------------------------------------------------------------------
SELECT e.employee_id, e.name, e.department_id, e.salary
FROM (
    SELECT employee_id, name, department_id, salary,
           AVG(salary) OVER (PARTITION BY department_id) AS avg_salary
    FROM employees
) e
WHERE e.salary > e.avg_salary;

/*
🔹 Explanation:
The AVG(salary) OVER (PARTITION BY department_id) calculates the average salary per department.
The outer query filters employees whose salary is greater than the department's average salary.
 */

-- Query Using a Subquery (Alternative)
SELECT e1.employee_id, e1.name, e1.department_id, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);
/*
🔹 Explanation:
The subquery calculates the average salary for each department.
The outer query filters employees who earn above their department’s average.
 */

-------------------------------------------------------------------------------
-- Write a query to find the most frequently occurring value in a column.
-------------------------------------------------------------------------------
-- Finding the Most Common Department
SELECT department_id, COUNT(*) AS frequency
FROM employees
GROUP BY department_id
ORDER BY frequency DESC
LIMIT 1;

-- Handling Ties (Multiple Most Frequent Values)
SELECT department_id, frequency
FROM (
    SELECT department_id, COUNT(*) AS frequency,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM employees
    GROUP BY department_id
) ranked
WHERE rank = 1;

-------------------------------------------------------------------------------
-- Fetch records where the date is within the last 7 days from today.
-------------------------------------------------------------------------------

SELECT *
FROM sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '7 days'; -- you can change the days value 

-------------------------------------------------------------------------------
-- Write a query to count how many employees share the same salary.
-------------------------------------------------------------------------------
SELECT salary, COUNT(*) AS employee_count
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;

-------------------------------------------------------------------------------
-- Write a query to fetch the top 3 records for each group in a table?
-------------------------------------------------------------------------------
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn <= 3;

/*
🔹 Explanation
ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
This assigns a row number (rn) to each employee within their department (department_id).
Employees are ordered by salary in descending order (ORDER BY salary DESC).
The outer query filters only the top 3 (WHERE rn <= 3) from each department.
 */

-- Alternative Using DENSE_RANK()
SELECT *
FROM (
    SELECT *, 
           DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM employees
) ranked
WHERE rnk <= 3;

-------------------------------------------------------------------------------
-- Retrieve products that were never sold (hint: use LEFT JOIN).
-------------------------------------------------------------------------------
SELECT p.*
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-------------------------------------------------------------------------------
-- Retrieve customers who made their first purchase in the last 6 months.
-------------------------------------------------------------------------------
SELECT c.*
FROM customers c
JOIN (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
) first_orders ON c.customer_id = first_orders.customer_id
WHERE first_orders.first_order_date >= CURRENT_DATE - INTERVAL '6 months';

/*
🔹 Explanation
Subquery (first_orders):
Finds the earliest order date (MIN(order_date)) for each customer_id.
Groups by customer_id to ensure we get only the first purchase.
Main Query:
Joins customers with first_orders to get customer details.
Filters customers whose first order date is within the last 6 months.
 */
-------------------------------------------------------------------------------
-- How do you pivot a table to convert rows into columns?
-------------------------------------------------------------------------------
SELECT departments,
       SUM(CASE WHEN month = 'Jan' THEN sales ELSE 0 END) AS Jan_Sales,
       SUM(CASE WHEN month = 'Feb' THEN sales ELSE 0 END) AS Feb_Sales
FROM sales
GROUP BY department;

-------------------------------------------------------------------------------
-- Write a query to calculate the percentage change in sales month-over-month.
-------------------------------------------------------------------------------
WITH MonthlySales AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS sales_month,
        SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT 
    sales_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales,
    CASE 
        WHEN LAG(total_sales) OVER (ORDER BY sales_month) IS NULL THEN NULL
        ELSE ROUND(((total_sales - LAG(total_sales) OVER (ORDER BY sales_month)) * 100.0) / 
                    LAG(total_sales) OVER (ORDER BY sales_month), 2)
    END AS percentage_change
FROM MonthlySales;

/*
Explanation:
The DATE_TRUNC('month', sales_date) extracts the month from sales_date.
SUM(sales_amount) calculates total sales per month.
The LAG(total_sales) OVER (ORDER BY sales_month) function retrieves the previous month's sales.
The percentage change is calculated using:
(current month sales − previous month sales / previous month sales) × 100
ROUND(..., 2) ensures the result is formatted to 2 decimal places.
 */
-------------------------------------------------------------------------------
-- Find the median salary of employees in a table.
-------------------------------------------------------------------------------

SELECT 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM employees;

/*
Explanation:
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary):
Computes the continuous percentile (50th percentile = median).
If the number of salaries is even, it interpolates between the two middle values.
If the number of salaries is odd, it directly picks the middle value.
FROM employees: Runs the calculation on the salary column of the employees table.
 */

-- Alternative: Using Window Functions
WITH EmployeeRank AS (
    SELECT salary, 
           ROW_NUMBER() OVER (ORDER BY salary) AS rn,
           COUNT(*) OVER () AS total_count
    FROM employees
)
SELECT AVG(salary) AS median_salary
FROM EmployeeRank
WHERE rn IN (FLOOR((total_count + 1) / 2.0), CEIL((total_count + 1) / 2.0));

/*
Explanation:
Assigns a row number (rn) ordered by salary.
Counts the total employees (total_count).
Finds the middle value(s):
If odd: Picks the middle row.
If even: Averages the two middle rows.
 */

-------------------------------------------------------------------------------
-- Fetch all users who logged in consecutively for 3 days or more.
-------------------------------------------------------------------------------
WITH LoginData AS (
    SELECT 
        user_id, 
        login_date, 
        LAG(login_date, 1) OVER (PARTITION BY user_id ORDER BY login_date) AS prev_day,
        LAG(login_date, 2) OVER (PARTITION BY user_id ORDER BY login_date) AS prev_2_days
    FROM user_logins
)
SELECT DISTINCT user_id
FROM LoginData
WHERE 
    login_date = prev_day + INTERVAL '1 day'
    AND prev_day = prev_2_days + INTERVAL '1 day';

/*
Explanation:
LAG(login_date, 1) → Gets the previous login date.
LAG(login_date, 2) → Gets the login date from two days before.
WHERE condition:
Ensures that the user logged in for 3 consecutive days.
DISTINCT user_id → Fetches unique users meeting the condition.
 */

-------------------------------------------------------------------------------
-- Write a query to delete duplicate rows while keeping one occurrence.
-------------------------------------------------------------------------------

WITH DuplicateRows AS (
    SELECT 
        employee_id, -- Assuming 'id' is the primary key
        ROW_NUMBER() OVER (
            PARTITION BY name, department_id, salary, hire_date
            ORDER BY employee_id
        ) AS row_num
    FROM employees
)
DELETE FROM employees
WHERE employee_id IN (
    SELECT employee_id FROM DuplicateRows WHERE row_num > 1
);

/*
Explanation:
ROW_NUMBER() OVER (PARTITION BY columns ORDER BY id)
Assigns a unique row number to each duplicate group.
Groups by name, department_id, salary, and hire_date (you can adjust as needed).
Orders by id (keeping the lowest id).
DELETE FROM employees WHERE id IN (...)
Deletes all duplicate records while keeping the first occurrence.
 */

-------------------------------------------------------------------------------
-- Create a query to calculate the ratio of sales between two categories.
-------------------------------------------------------------------------------

SELECT 
    SUM(CASE WHEN p.category = 'Electronics' THEN s.sale_amount ELSE 0 END) AS electronics_sales,
    SUM(CASE WHEN p.category = 'Furniture' THEN s.sale_amount ELSE 0 END) AS furniture_sales,
    CASE 
        WHEN SUM(CASE WHEN p.category = 'Furniture' THEN s.sale_amount ELSE 0 END) = 0 
        THEN NULL -- Avoid division by zero
        ELSE 
            SUM(CASE WHEN p.category = 'Electronics' THEN s.sale_amount ELSE 0 END) * 1.0 / 
            SUM(CASE WHEN p.category = 'Furniture' THEN s.sale_amount ELSE 0 END)
    END AS sales_ratio
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN order_items oi ON s.employee_id = oi.order_id  -- Assuming sales are linked to orders
JOIN products p ON oi.product_id = p.product_id;

/*
Explanation:
Conditional Aggregation (CASE WHEN):
Summing up sales amounts separately for Electronics and Furniture categories.
Ratio Calculation:
(Electronics Sales) / (Furniture Sales).
If Furniture Sales is 0, the ratio is set to NULL to avoid division by zero.
 */

-------------------------------------------------------------------------------
-- How would you implement a recursive query to generate a hierarchical structure?
-------------------------------------------------------------------------------

SELECT 
    senior.employee_id AS senior_employee_id, 
    senior.name AS senior_employee_name, 
    junior.employee_id AS junior_employee_id, 
    junior.name AS junior_employee_name, 
    senior.department_id
FROM employees senior
JOIN employees junior 
    ON senior.department_id = junior.department_id 
    AND senior.salary > junior.salary 
ORDER BY senior.department_id, senior.salary DESC;


WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor: Start with the highest-paid employee in each department
    SELECT 
        employee_id, 
        name, 
        department_id, 
        salary, 
        1 AS hierarchy_level
    FROM employees 
    WHERE salary = (SELECT MAX(salary) FROM employees e2 WHERE e2.department_id = employees.department_id)

    UNION ALL

    -- Recursive: Find employees with lower salaries in the same department
    SELECT 
        e.employee_id, 
        e.name, 
        e.department_id, 
        e.salary, 
        eh.hierarchy_level + 1
    FROM employees e
    JOIN EmployeeHierarchy eh
        ON e.department_id = eh.department_id 
        AND e.salary < eh.salary
)
SELECT * FROM EmployeeHierarchy
ORDER BY department_id, hierarchy_level;

-------------------------------------------------------------------------------
-- Write a query to find gaps in sequential numbering within a table.
-------------------------------------------------------------------------------
-- Approach 1: Using a Window Function
SELECT e1.employee_id AS missing_after, e1.employee_id + 1 AS missing_value
FROM employees e1
LEFT JOIN employees e2 ON e1.employee_id + 1 = e2.employee_id
WHERE e2.employee_id IS NULL
ORDER BY e1.employee_id;

/*
Explanation
It checks if there is an employee_id that is missing by comparing each employee_id + 1 with the next employee_id.
If e2.employee_id is NULL, it means a gap exists
 */

-- Approach 2: Using a Recursive CTE to Detect Missing Numbers
WITH RECURSIVE sequence AS (
    SELECT MIN(employee_id) AS num FROM employees  -- Start from the smallest ID
    UNION ALL
    SELECT num + 1 FROM sequence 
    WHERE num < (SELECT MAX(employee_id) FROM employees)
)
SELECT num AS missing_value
FROM sequence
LEFT JOIN employees e ON sequence.num = e.employee_id
WHERE e.employee_id IS NULL;


-------------------------------------------------------------------------------
-- Split a comma-separated string into individual rows using SQL.
-------------------------------------------------------------------------------
-- If the delimiter could be multiple characters or spaces, use:
SELECT regexp_split_to_table('John, Emma, Michael, Sophia', '\s*,\s*') AS names;

-- If you're working with a table column, use unnest(string_to_array()):
SELECT unnest(string_to_array('John,Emma,Michael,Sophia', ',')) AS names;

SELECT employee_id, unnest(string_to_array(employees."name" , ',')) AS value
FROM employees;

-------------------------------------------------------------------------------
-- Rank products by sales in descending order for each region.
-------------------------------------------------------------------------------
-- Option 1: Rank Products by Sales Globally
SELECT 
    p.product_name,
    SUM(oi.quantity * oi.price) AS total_sales,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.price) DESC) AS sales_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- Option 2: Rank Products by Sales per Customer
SELECT 
    c.customer_id,
    p.product_name,
    SUM(oi.quantity * oi.price) AS total_sales,
    RANK() OVER (PARTITION BY c.customer_id ORDER BY SUM(oi.quantity * oi.price) DESC) AS sales_rank
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, p.product_name;

-------------------------------------------------------------------------------
-- Fetch all employees whose salaries fall within the top 10% of their department.
-------------------------------------------------------------------------------
SELECT employee_id, name, department_id, salary
FROM (
    SELECT 
        employee_id, 
        name, 
        department_id, 
        salary,
        PERCENT_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM employees
) ranked
WHERE salary_rank <= 0.10;

/*
Explanation:
The inner query:

Uses PERCENT_RANK() to rank employees within their department based on salary DESC (highest salaries first).
The rank is a percentage (0 to 1), where 0.10 represents the top 10%.
The outer query:

Filters out employees where salary_rank > 0.10, keeping only those in the top 10% of salaries within each department. 
 */

-------------------------------------------------------------------------------
-- Identify orders placed during business hours (e.g., 9 AM to 6 PM).
-------------------------------------------------------------------------------
SELECT order_id, customer_id, order_date
FROM orders
WHERE EXTRACT(HOUR FROM order_date) BETWEEN 9 AND 18;

/*
Explanation:
EXTRACT(HOUR FROM order_date) retrieves the hour (0-23) from the order_date timestamp.
BETWEEN 9 AND 18 filters orders where the hour falls between 9 AM and 6 PM (including both 9 and 6).
 */

-- Alternative: Using TO_CHAR() for More Control
SELECT order_id, customer_id, order_date
FROM orders
WHERE TO_CHAR(order_date, 'HH24:MI') BETWEEN '09:00' AND '18:00';

-------------------------------------------------------------------------------
-- Write a query to get the count of users active on both weekdays and weekends.
-------------------------------------------------------------------------------

SELECT COUNT(*) AS active_users
FROM (
    SELECT user_id
    FROM user_logins
    GROUP BY user_id
    HAVING 
        COUNT(CASE WHEN EXTRACT(DOW FROM login_date) IN (1,2,3,4,5) THEN 1 END) > 0
        AND 
        COUNT(CASE WHEN EXTRACT(DOW FROM login_date) IN (0,6) THEN 1 END) > 0
) AS filtered_users;

/*
Explanation:
EXTRACT(DOW FROM login_date) extracts the day of the week (0 = Sunday, 1 = Monday, ..., 6 = Saturday).
Filtering Users:
IN (1,2,3,4,5) checks for logins on weekdays (Monday-Friday).
IN (0,6) checks for logins on weekends (Saturday-Sunday).
HAVING COUNT(...) > 0 ensures the user has logged in at least once on both a weekday and a weekend.
The outer query counts the number of such users.
 */

-------------------------------------------------------------------------------
-- Retrieve customers who made purchases across at least three different categories
-------------------------------------------------------------------------------
SELECT c.customer_id, c.name, COUNT(DISTINCT p.category) AS category_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT p.category) >= 3;

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------





-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------





-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------





-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------





-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
