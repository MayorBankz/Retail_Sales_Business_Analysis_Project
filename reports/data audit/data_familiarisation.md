# Retail Sales & Business Performance Analysis
## Data Familiarisation and Key Validation

### 1. Introduction

This document records the data familiarisation and key validation activities carried out as part of the Retail Sales and Business Performance Analysis project.

The objective of this stage is to understand the structure of the dataset, identify potential primary and foreign keys, investigate duplicate records, and validate relationships between the different tables before proceeding with data cleaning and analysis.

### 2. Dataset Overview

The dataset consists of eight related tables containing information about customers, products, suppliers, stores, staff, orders, and order items.

| Table | Description | Primary Key Candidate | Rows | Columns |
|---|---|---|---:|---:|
| customers | Customer information and details | customer_id | 241 | 7 |
| categories | Product category information | category_id | 8 | 2 |
| products | Product details and pricing information | product_id | 55 | 7 |
| suppliers | Supplier information | supplier_id | 18 | 4 |
| stores | Store information and locations | store_id | 8 | 6 |
| staff | Employee information | staff_id | 24 | 5 |
| orders | Customer order and transaction details | order_id | 2,600 | 8 |
| order_items | Individual products included in customer orders | (order_id, line_number) | 4,174 | 6 |

*Note: The primary key candidates are subject to uniqueness and completeness validation.*
### 3. Understanding the Table Structure

The tables were inspected to understand the information stored in each one and how they relate to one another.

The following observations were made:

* The customers table contains customer details.
* The categories table contains product category information.
* The products table contains product details, pricing and references to categories and suppliers.
* The suppliers table contains supplier information.
* The stores table contains store details and locations.
* The staff table contains employee information and their associated stores.
* The orders table contains transaction-level information, including customer, store, staff, date and payment details.
* The order_items table contains individual products associated with each other, including quantity, unit price and discount information.

### 4. Understanding Orders and Order Items

A distinction was established between the orders and order_items tables.

* One row in orders represent one customer order.
* One row in order_items represents an individual product line within an order.

An order may contain multiple products. Separating orders from order items prevents the repitition of order-level information for every product included in an order.

### 5. Identification of Primary and Foreign Keys

Primary keys are used to uniquely identify records within a table, while foreign keys establish relationships between related tables.

The following potential relationships were identified:

| Child Table | Foreign Key | Parent Table | Referenced Primary Key |
|---|---|---|---|
| orders | customer_id | customers | customer_id |
| orders | store_id | stores | store_id |
| orders | staff_id | staff | staff_id |
| order_items | order_id | orders | order_id |
| order_items | product_id | products | product_id |
| products | category_id | categories | category_id |
| products | supplier_id | suppliers | supplier_id |
| staff | store_id | stores | store_id |

These relationships are being validated to confirm that foreign key values correspond to existing records in their respective parent tables.

### 6. Primary Key Validation

Initial checks were carried out to investigate whether the identified columns could serve as primary keys.

**Findings:**

### 6.1 Customers Table

The customer_id column was checked for duplicate values.

Result: No duplicate values were identified.

This supports customer_id as a primary key candidate, subject to checking for missing values.

### 6.2 Order Items Table

The order_id column contains repeated values.

This is expected because one customer order can contain multiple products.

Further investigation was conducted using the combination of order_id and line_number.

One duplicate record was identified during the investigation.

The combination of order_id and line_number is therefore the proposed composite primary key for the table,
but its uniqueness must be confirmed after resolving the duplicate.

### 7. Duplicate Record Investigation

During the validation of the `order_items` table, duplicate record was identified.

The investigation established that one row was duplicated. The record was flagged for review.

No records were deleted or modified during this exercise.

**Reason for investigation:** Duplicate records can affect transaction counts, product quantities and revenue calculations
if they are included in analysis without proper assessment. 

### 8. Foreign Key Validation Using SQL

SQL LEFT JOIN operations were used to identify unmatched foreign key records across the related tables.

The approach involved :

1. Selecting the child table.
2. Performing a LEFT JOIN with the parent table.
3. Matching the foreign key to the referenced primary key.
4. Filtering for NULL values in the parent table's key column.

#### 8.1 Orders to Customers

Relationship: `orders.customer_id` → `customers.customer_id`

```sql
SELECT *
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```

Purpose: Identify orders whose customer IDs do not exist in the customers table.

#### 8.2 Orders to Stores

Relationship: `orders.store_id` → `stores.store_id`

```sql
SELECT *
FROM orders AS o
LEFT JOIN stores AS s
    ON o.store_id = s.store_id
WHERE s.store_id IS NULL;
```

Purpose: Identify orders whose store IDs do not exist in the stores table.

#### 8.3 Orders to Staff

Relationship: `orders.staff_id` → `staff.staff_id`

```sql
SELECT *
FROM orders AS o
LEFT JOIN staff AS s
    ON o.staff_id = s.staff_id
WHERE s.staff_id IS NULL;
```

Purpose: Identify orders containing staff IDs that cannot be matched to the staff table.

#### 8.4 Order Items to Products 

Relationship: `order_items.product_id` → `products.product_id`

```sql
SELECT *
FROM order_items AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
```

Purpose: Identify order items containing product IDs that cannot be matched to the products table.

#### 8.5 Products to Categories

Relationship: `products.category_id` → `categories.category_id`

```sql
SELECT *
FROM products AS p
LEFT JOIN categories AS c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;
```

Purpose: Identify products whose category IDs do not exist in the categories table.

### 8.6 Orders Items to Orders

Relationship: `Order_items.order_id` →  `orders.order_id` 

```sql
SELECT *
FROM order_items AS oi
LEFT JOIN orders AS o
	ON o.order_id = oi.order_id
WHERE o.order_id IS NULL
```

Purpose: Identify order items whose order IDs do not exist in the orders table.

### 8.7 Products to Suppliers

Relationship: `products.supplier_id` → `suppliers.supplier_id`

```sql
SELECT *
FROM products AS p
LEFT JOIN suppliers AS s
	ON p.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL
```

Purpose: Identify products whose suppliers IDs cannot be found in the suppliers table

### 8.8 Staff to Stores

Relationship : `staff.store_id` → `stores.store_id`

```sql
SELECT *
FROM staff AS s
LEFT JOIN stores AS st
    ON s.store_id = st.store_id
WHERE st.store_id IS NULL
```
Purpose: Identify staff records containing store IDs that do not exist in the stores table.

### 9. Foreign Key Validation Results

All eight foreign keys validation queries were executed successfully using SQL LEFT JOIN operations.

The objective was to identify unmatched foreign key values that could indicate orphan records or inconsistencies 
between related tables

### Validation Results

| No. | Relationship | Unmatched Records | Status |
| ---- | ---- | --- | ---- |
| 1 | Orders → Customers | 0 | Passed |
| 2 | Orders → Stores | 0 | Passed |
| 3 | Orders → Staff | 0 | Passed |
| 4 | Order Items → Orders | 0 | Passed |
| 5 | Order Items → Products | 0 | Passed | 
| 6 | Products → Categories | 0 | Passed |     
| 7 | Products → suppliers | 0 | Passed |
| 8 | Staff → Stores | 0 | Passed | 

**Findings** 

All eight validation queries returned zero unmatched records.

This indicates that the foreign key values checked in the child tables have corresponding records in their respective
parent tables.

No orphan records were identified during these checks.

### 10. Key Finidings and Observations

The following activities have been completed:

1. Inspected all eight tables and documented their structures.
2. Identified potential primary keys and foreign key relationships.
3. Established the difference between order-level and order-item-level records.
4. Checked customers.customer_id for duplicate values and found none.
5. Investigated repeated order_id values in the order_items table.
6. Identified one duplicate record during the composite key investigation.
7. Wrote SQL queries to validate all eight identified foreign key relationships

### 9. Conclusion

The data familiarisation and key validation stage has provided an understanding of the dataset
structure and its potential relationship.

The next objective is to complete the outstanding validation checks and proceed with a detailed 
data quality assessment before preparing the dataset for business analysis. 