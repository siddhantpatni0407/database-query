# Joins Database

## Overview
This document provides an overview of the `joins_db` database schema, including its tables, relationships, and commonly used SQL queries for SQL joins.

## Database Schema
The `joins_db` database consists of multiple tables managing employees, sales, products, orders, customers, and user logins.

## Database Relationships
```mermaid
erDiagram
    EMPLOYEES {
        int employee_id PK
        string name
        int department_id FK
        decimal salary
    }
    DEPARTMENTS {
        int department_id PK
        string department_name
    }
    SALES {
        int sale_id PK
        int employee_id FK
        decimal sale_amount
    }
    CUSTOMERS {
        int customer_id PK
        string name
        string email
    }
    ORDERS {
        int order_id PK
        int customer_id FK
        timestamp order_date
    }
    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int product_id
        int quantity
        decimal price
    }

    EMPLOYEES ||--o{ DEPARTMENTS : "belongs to"
    EMPLOYEES ||--o{ SALES : "makes"
    CUSTOMERS ||--o{ ORDERS : "places"
    ORDERS ||--o{ ORDER_ITEMS : "contains"
```
