-- Basic Queries
-- Fetch all employees
SELECT * FROM employees;

-- Get employees with salary > 60000
SELECT * FROM employees WHERE salary > 60000;

-- Count employees by department
SELECT department, COUNT(*) FROM employees GROUP BY department;

-- Get highest-paid employee
SELECT * FROM employees ORDER BY salary DESC LIMIT 1;

-- Find the department with the most employees
SELECT department, COUNT(*) AS employee_count 
FROM employees 
GROUP BY department 
ORDER BY employee_count DESC 
LIMIT 1;

-- Advanced Queries
-- Get employees with salaries above average
SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

-- Get 2nd highest salary
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 1 OFFSET 1;

-- Find employees hired in the last 6 months
SELECT * FROM employees WHERE hire_date >= NOW() - INTERVAL '6 months';

-- Use a JOIN to get employees with department names
SELECT e.name, e.salary, d.department_name 
FROM employees e 
JOIN departments d ON e.department = d.department_name;