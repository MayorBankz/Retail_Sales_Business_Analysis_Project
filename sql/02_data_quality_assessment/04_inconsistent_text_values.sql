-- ============================================================================
-- DATA QUALITY ASSESSMENT (INCONSISTENT TEXT VALUES)
-- DATE: 20//11/2026.
-- ============================================================================

-- ============================================================================
-- 	1.0 CUSTOMERS TABLE CHECK FOR INCONSISTENT TEXT VALUES
-- ============================================================================

select distinct
	customer_type
from customers
order by customer_type
;
-- ============================================================================
-- 	1.1  INVESTIGATE THE AFFECTED RECORDS IN CUSTOMERS TABLE 
-- ============================================================================

select 
	customer_id,
    customer_name,
    customer_type
from customers
where binary customer_type = 'retail';

-- BINARY makes the comparison case-sensitive in MySQL, helping us isolate
-- the lowercase entries

-- ============================================================================
-- 	1.2  CUSTOMERS TABLE DIAGNOSTIC CHECK  
-- ============================================================================
select
	customer_type,
    concat('[', customer_type, ']') as visible_value,
    length(customer_type) as value_length,
    hex(customer_type) as stored_value
from customers
group by customer_type;

-- ============================================================================
-- 	1.3  IDENTIFY THE AFFECTED RECORDS IN CUSTOMERS TABLE 
-- ============================================================================

select 
	customer_id,
    customer_name,
    concat('[', customer_type, ']') as customer_type
from customers
where trim(customer_type) <> 'Retail'
	and lower(trim(customer_type)) = 'retail';

-- ============================================================================
-- 	1.4  CORRECT THE INCONSISTENCY IN CUSTOMER TABLE 
-- ============================================================================

update customers 
set customer_type = 'Retail'
where lower(trim(customer_type)) = 'retail';

-- ============================================================================
-- 	1.5  VERIFY THE CORRECTION IN CUSTOMER TABLE 
-- ============================================================================

select distinct customer_type
from customers
order by customer_type;

-- ============================================================================
-- 	2.0 PRODUCTS TABLE CHECK FOR INCONSISTENT TEXT VALUES
-- ============================================================================ 

select distinct 
	product_name
from products
order by product_name;

-- ============================================================================
-- 	2.1 INVESTIGATE THE AFFECTED PRODUCT NAME IN PRODUCT TABLE
-- ============================================================================ 

select 
	product_id,
    concat('[', product_name, ']') as visible_name,
    length(product_name) as original_length,
    length(trim(product_name)) as cleaned_length,
    hex(product_name) as stored_value
from products
where trim(product_name) <> product_name;

-- ============================================================================
-- 	2.2  CORRECT THE INCONSISTENCY IN CUSTOMER TABLE 
-- ============================================================================

update products
set product_name = 'Green Tea 25 Bags'
where product_id = 'P0006';

-- ============================================================================
-- 	2.3  VERIFY THE CORRECTION  
-- ============================================================================

select
	product_id,
    concat('[', product_name, ']') as product_name,
    length(product_name) as name_length,
    hex(product_name) as stored_value
from products
where product_id = 'P0006'
;

-- ============================================================================
-- 	3.0 STORES TABLE CHECK FOR INCONSISTENT TEXT VALUES
-- ============================================================================ 
select distinct
	store_name
from stores
order by store_name;

-- ============================================================================
-- 	3.1 INVESTIGATE THE AFFECTED STORE NAME IN STORE TABLE
-- ============================================================================

select
	store_id,
    concat('[', store_name, ']') as visible_name,
    length(store_name) as original_length,
    length(trim(store_name)) as cleaned_length,
    hex(store_name) as stored_value
from stores
where trim(store_name) <> store_name;

-- ============================================================================
-- 	3.2  CORRECT THE STORE NAME IN STORE TABLE 
-- ============================================================================

update stores
set store_name = 'Yaba Market'
where store_id = 'STR003';

-- ============================================================================
-- 	3.3  VERIFY THE CORRECTION  
-- ============================================================================

select 
	store_id,
    concat('[', store_name, ']') as store_name,
    length(store_name) as name_length
from stores
where store_id = 'STR003';

-- ============================================================================
-- 	4.0 SUPPLIERS TABLE CHECK FOR INCONSISTENT TEXT VALUES
-- ============================================================================
select distinct 
	supplier_name
from suppliers 
order by supplier_name;

-- ============================================================================
-- 	4.1 INVESTIGATE THE AFFECTED SUPPLIER NAME IN SUPPLIERS TABLE
-- ============================================================================

select
	supplier_id,
    concat('[', supplier_name, ']') as visible_name,
    length(supplier_name) as original_length,
    length(trim(supplier_name)) as cleaned_length,
    hex(supplier_name) as stored_value
from suppliers
where trim(supplier_name) <> supplier_name
;

-- The result returned no records which means no supplier names contain ordinary
-- leading or trailing spaces.

-- ============================================================================
-- 	4.2 SUPPLIERS TABLE CHECK FOR INCOSISTENT TEXT VALUES IN SUPPLIER REGION
-- ============================================================================

select distinct
	supplier_region
from suppliers
order by supplier_region;

-- ============================================================================
-- 	4.3 INVESTIGATE THE AFFECTED SUPPLIER REGION IN SUPPLIER TABLE
-- ============================================================================

select 
	supplier_id,
    concat('[', supplier_name, ']') as visible_region,
    length(supplier_region) as original_region,
    length(trim(supplier_region)) as cleaned_region,
    hex(supplier_region) as stored_value
from suppliers
where trim(supplier_region) <> supplier_region;
	
-- ============================================================================
-- 	5.0 STAFF TABLE CHECK FOR INCONSISTENT TEXT VALUES
-- ============================================================================

select distinct 
	staff_name
from staff
order by staff_name;

-- ============================================================================
-- 	5.1 INVESTIGATE THE AFFECTED STAFF NAME IN STAFF TABLE
-- ============================================================================

select
	staff_id,
    concat('[', staff_name, ']') as visible_name,
    length(staff_name) as original_length,
    length(trim(staff_name)) as cleaned_length,
    hex(staff_name) as stored_value
from staff
where trim(staff_name) <> staff_name;

-- The result returned no records, which mean no staff name contain
-- leading or trailing spaces.

-- ============================================================================
-- 	5.2 STAFF ROLE CHECK FOR INCONSISTENT TEXT VALUES
-- ============================================================================

select distinct	
	role
from staff
order by role;

-- ============================================================================
-- 	5.3 INVESTIGATE THE AFFECTED ROLE IN STAFF TABLE
-- ============================================================================

select 
	staff_id,
	concat('[', role, ']') as visible_role,
    length(role) as original_length,
    length(trim(role)) as cleaned_length,
    hex(role) as stored_value
from staff
where trim(role) <> role;

-- ============================================================================
-- 	6.0 ORDERS TABLE CHECK FOR INCONSISTENT VALUES IN SALES_CHANNEL COLUMN
-- ============================================================================

-- sales_channel check

select distinct
	sales_channel
from orders 
order by sales_channel;

-- ============================================================================
-- 	6.1 INVESTIGATE THE AFFECTED SALES CHANNEL IN ORDERS TABLE
-- ============================================================================

select
	order_id,
    concat(']', sales_channel, ']') as visible_channel,
    length(sales_channel) as original_length,
    length(trim(sales_channel)) as cleaned_length,
    hex(sales_channel) as stored_value
from orders
where trim(sales_channel) <> sales_channel;

-- ============================================================================
-- 	6.3 ORDERS TABLE CHECK FOR INCONSISTENT VALUES IN PAYMENT METHOD COLUMN
-- ============================================================================

select distinct
	payment_method
from orders
order by payment_method;

-- ============================================================================
-- 	6.4 INVESTIGATE THE AFFECTED PAYMENT METHOD IN ORDERS TABLE
-- ============================================================================

select
	order_id,
    concat('[', payment_method, ']') as visible_payment,
    length(payment_method) as original_length,
    length(trim(payment_method)) as cleaned_length,
    hex(payment_method) as stored_value
from orders
where trim(payment_method) <> payment_method;

-- ============================================================================
-- 	6.5 ORDERS TABLE CHECK FOR INCONSISTENT VALUES IN ORDER STATUS COLUMN
-- ============================================================================

select	distinct
	order_status
from orders
order by order_status;

-- ============================================================================
-- 	6.6 INVESTIGATE THE AFFECTED ORDER STATUS IN ORDERS TABLE
-- ============================================================================

select
	order_id,
    concat('[', order_status, ']') as visible_status,
    length(order_status) as original_length,
    length(trim(order_status)) as cleaned_length,
    hex(order_status) as stored_value
from orders
where trim(order_status) <> order_status;

-- ============================================================================
-- 	7.0 CATEGORIES TABLE CHECK FOR INCONSISTENT VALUES IN CATEGORY NAME COLUMN
-- ============================================================================

select distinct
	category_name
from categories
order by category_name;

-- ============================================================================
-- 	7.0 INVESTIGATE THE AFFECTED CATEGORY NAME IN CATEGORIES TABLE
-- ============================================================================

select 
	category_id,
    concat('[', category_name, ']') as visible_category,
    length(category_name) as original_length,
    length(trim(category_name)) as cleaned_length,
    hex(category_name) as stored_value
from categories
where trim(category_name) <> category_name;