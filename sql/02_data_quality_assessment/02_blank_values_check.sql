-- ============================================================================
-- DATA QUALITY ASSESSMENT (BLANK VALUES CHECK)
-- DATE: 18//11/2026.
-- ============================================================================


-- ============================================================================
-- 1. CHECK FOR BLANK VALUES IN CUSTOMERS TABLE
-- ============================================================================

select
    sum(case when trim(customer_name) = '' then 1 else 0 end) as blank_customer_name,
    sum(case when trim(customer_type) = '' then 1 else 0 end) as blank_customer_type,
    sum(case when trim(city) = '' then 1 else 0 end) as blank_city,
    sum(case when trim(state) = '' then 1 else 0 end) as  blank_state,
    sum(case when trim(preferred_channel) = '' then 1 else 0 end) as blank_preferred_channel
from customers;

-- ============================================================================
-- 2. CHECK FOR BLANK VALUES IN CATEGORIES TABLE
-- ============================================================================

select
    sum(case when trim(category_name) = '' then 1 else 0 end) as blank_category_name
from categories;

-- ============================================================================
-- 3. CHECK FOR BLANK VALUES IN ORDERS TABLE
-- ============================================================================

select
	sum(case when trim(sales_channel) = '' then 1 else 0 end) as blank_sales_channel,
    sum(case when trim(payment_method) = '' then 1 else 0 end) as blank_payment_method,
    sum(case when trim(order_status) = '' then 1 else 0 end) as blank_order_status
from orders;

-- ============================================================================
-- 4. CHECK FOR BLANK VALUES IN PRODUCTS TABLE
-- ============================================================================

select 
	sum(case when trim(product_name) = '' then 1 else 0 end) as blank_product_name
from products;

-- ============================================================================
-- 5. CHECK FOR BLANK VALUES IN STAFF TABLE 
-- ============================================================================

select 
	sum(case when trim(staff_name) = '' then 1 else 0 end) as blank_staff_name,
    sum(case when trim(role) = '' then 1 else 0 end) as blank_role
from staff;

-- ============================================================================
-- 6. CHECK FOR BLANK VALUES IN STORES TABLE
-- ============================================================================
select 
	sum(case when trim(store_name) = '' then 1 else 0 end) as blank_store_name,
    sum(case when trim(city) = '' then 1 else 0 end) as blank_city,
    sum(case when trim(state) = '' then 1 else 0 end) as blank_state,
    sum(case when trim(store_type) = '' then 1 else 0 end) as blank_store_type
from stores;


-- ============================================================================
-- 7. CHECK FOR BLANK VALUES IN SUPPLIERS TABLE
-- ============================================================================

select 
	sum(case when trim(supplier_name) = '' then 1 else 0 end) as blank_supplier_name,
    sum(case when trim(supplier_region) = '' then 1 else 0 end) as blank_supplier_region
from suppliers;

-- ============================================================================
-- INVESTIGATION OF CITY COLUMN IN CUSTOMERS TABLE 
-- ============================================================================

select
	customer_id,
    customer_name,
    customer_type,
    city,
    state
from customers
where trim(city) = '';

update customers
set city = 'unknown'
where city = ''
;

