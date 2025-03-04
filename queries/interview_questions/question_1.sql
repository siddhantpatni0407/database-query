-- 	Problem Definition : Find Top 3 Highest Paid Employees in Each Department
--------------------------------------------------------------------------------

-- 	SQL Query : 1 - Using DENSE_RANK() 

WITH RankedEmployees AS (
    SELECT e.employee_id, 
           e.first_name, 
           e.last_name, 
           e.salary, 
           d.department_name,
           DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank
    FROM Employees e
    JOIN Departments d ON e.department_id = d.id
)
SELECT employee_id, first_name, last_name, salary, department_name 
FROM RankedEmployees
WHERE rank <= 3
ORDER BY department_name, rank, salary DESC;


/*
Explanation of the Query
WITH RankedEmployees AS (...)

We use a Common Table Expression (CTE) to calculate ranks for employees within each department.
DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) assigns a rank based on salary for each department.
If multiple employees have the same salary, they get the same rank (unlike RANK(), which may skip rankings).
Filtering Top 3 Salaries Per Department

The WHERE rank <= 3 ensures that only the top 3 highest-paid employees in each department are selected.
Sorting the Output

We order the final result by department_name, rank, and salary DESC for clarity.

*/
--------------------------------------------------------------------------------

-- 	SQL Query : 2 - Using Using RANK()

WITH RankedEmployees AS (
    SELECT e.employee_id, 
           e.first_name, 
           e.last_name, 
           e.salary, 
           d.department_name,
           RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank
    FROM Employees e
    JOIN Departments d ON e.department_id = d.id
)
SELECT employee_id, first_name, last_name, salary, department_name 
FROM RankedEmployees
WHERE rank <= 3
ORDER BY department_name, rank, salary DESC;

--------------------------------------------------------------------------------

-- 	SQL Query : 3 - Using ROW_NUMBER()

SELECT employee_id, first_name, last_name, department_id, salary
FROM (
    SELECT e.*, 
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS row_num
    FROM Employees e
) ranked
WHERE row_num <= 3;

/*Difference from DENSE_RANK()
ROW_NUMBER() assigns a unique rank to each row, even if salaries are the same.
This may result in exactly 3 employees per department, but some top earners might be skipped if there are ties.
*/

--------------------------------------------------------------------------------

-- 	SQL Query : 4 - Using LIMIT (Database-Specific)
--	For MySQL, which doesn't support RANK(), use LIMIT with a correlated subquery.

SELECT e1.*
FROM Employees e1
WHERE (
    SELECT COUNT(DISTINCT e2.salary)
    FROM Employees e2
    WHERE e2.department_id = e1.department_id
    AND e2.salary > e1.salary
) < 3
ORDER BY e1.department_id, e1.salary DESC;

/*
Explanation
The subquery counts the number of unique salaries greater than the current employee's salary.
If fewer than 3 salaries are greater, the employee is among the top 3.
*/

--------------------------------------------------------------------------------