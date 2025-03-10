-----------------------------------------------------------
-- 1. INNER JOIN
-- Retrieves records that have matching values in both tables.

SELECT e.employee_id, e.name, e.salary, d.department_name
FROM employees e
INNER JOIN departments d 
ON e.department_id = d.department_id;

-- Returns: Employees who belong to a department.
-----------------------------------------------------------
-- 2. LEFT JOIN (or LEFT OUTER JOIN)
-- Retrieves all records from the left table and matching records from the right table. If no match, NULL is returned.

SELECT e.employee_id, e.name, e.salary, d.department_name
FROM employees e
LEFT JOIN departments d 
ON e.department_id = d.department_id;

-- Returns: All employees, even those without a department (Emma).
-----------------------------------------------------------
-- 3. RIGHT JOIN (or RIGHT OUTER JOIN)
-- Retrieves all records from the right table and matching records from the left table. If no match, NULL is returned.

SELECT e.employee_id, e.name, e.salary, d.department_name
FROM employees e
RIGHT JOIN departments d 
ON e.department_id = d.department_id;

-- Returns: All departments, even if no employees are assigned.
-----------------------------------------------------------
-- 4. FULL OUTER JOIN
-- Retrieves all records when there is a match in either table.

SELECT e.employee_id, e.name, e.salary, d.department_name
FROM employees e
FULL OUTER JOIN departments d 
ON e.department_id = d.department_id;

-- Returns: All employees and all departments, filling unmatched columns with NULL.
-----------------------------------------------------------
-- 5. CROSS JOIN
-- Returns the Cartesian product of both tables (every possible combination).

SELECT e.name, d.department_name
FROM employees e
CROSS JOIN departments d;

-- Returns: Every employee with every department.
-----------------------------------------------------------
-- 6. SELF JOIN
-- A table joins with itself (useful for hierarchical data like managers).

SELECT e1.name AS Employee, e2.name AS Manager
FROM employees e1
LEFT JOIN employees e2 
ON e1.department_id = e2.department_id
AND e1.employee_id <> e2.employee_id;

-- Returns: Employees and their colleagues in the same department.
-----------------------------------------------------------
-- 7. JOIN Multiple Tables
-- Example fetching employee sales details.

SELECT e.name, s.sale_amount, d.department_name
FROM employees e
JOIN sales s 
ON e.employee_id = s.employee_id
JOIN departments d ON e.department_id = d.department_id;

-- Returns: Employee sales with department details.
-----------------------------------------------------------