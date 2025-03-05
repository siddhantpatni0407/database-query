psql -U postgres -f "1_create_database_business_ops_db_scripts.sql"
psql -U postgres -d business_ops_db -f "2_create_table.sql"
psql -U postgres -d business_ops_db -f "3_insert_bulk_data.sql"


SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

select * from customers;
select * from departments;
select * from employees;
select * from order_items;
select * from orders;
select * from products;
select * from sales;
select * from user_logins;
