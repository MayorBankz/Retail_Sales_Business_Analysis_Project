-- ============================================================================
-- DATA QUALITY ASSESSMENT (MISSING VALUES CHECK)
-- DATE: 18//11/2026.
-- ============================================================================

-- ============================================================================
-- 1. MISSING VALUES CHECK IN CUSTOMERS TABLE
-- ============================================================================

select 
	sum(case when customer_id is null then 1 else 0 end) as missing_customer_id,
	sum(case when customer_name is null then 1 else 0 end) as missing_customer_name,
    sum(case when customer_type is null then 1 else 0 end) as missing_customer_type,
    sum(case when city is null then 1 else 0 end) as missing_city,
    sum(case when state is null then 1 else 0 end) as missing_state,
    sum(case when signup_date is null then 1 else 0 end) as missing_signup_date,
    sum(case when preferred_channel is null then 1 else 0 end) as missing_preferred_channel
from customers;


-- ============================================================================
-- 2. MISSING VALUES CHECK IN CATEGORIES TABLE
-- ============================================================================

select 
	sum(case when category_id is null then 1 else 0 end) as missing_category_id,
    sum(case when category_name is null then 1 else 0 end) as missing_category_name
from categories;



-- ============================================================================
-- 3. MISSING VALUES CHECK IN ORDER ITEMS TABLE
-- ============================================================================

select 
	sum(case when order_id is null then 1 else 0 end) as missing_order_id,
    sum(case when line_number is null then 1 else 0 end) as missing_line_number,
    sum(case when product_id is null then 1 else 0 end) as missing_product_id,
    sum(case when quantity is null then 1 else 0 end) as missing_quantity,
    sum(case when unit_price is null then 1 else 0 end) as missing_unit_price,
    sum(case when discount_pct is null then 1 else 0 end) as missing_discount_pct
from order_items;

-- ============================================================================
-- 4. MISSING VALUES CHECK IN ORDERS TABLE
-- ============================================================================
select 
	sum(case when order_id is null then 1 else 0 end) as missing_order_id,
    sum(case when order_date is null then 1 else 0 end) as missing_order_date,
    sum(case when customer_id is null then 1 else 0 end) as missing_customer_id,
    sum(case when store_id is null then 1 else 0 end) as missing_store_id,
    sum(case when staff_id is null then 1 else 0 end) as missing_staff_id,
    sum(case when sales_channel is null then 1 else 0 end) as missing_sales_channel,
    sum(case when payment_method is null then 1 else 0 end) as missing_payment_method,
    sum(case when order_status is null then 1 else 0 end) as missing_order_status
from orders;



-- ============================================================================
-- 5. MISSING VALUES CHECK IN PRODUCTS TABLE
-- ============================================================================

select 
	sum(case when product_id is null then 1 else 0 end) as missing_product_id,
    sum(case when product_name is null then 1 else 0 end) as missing_product_name,
    sum(case when category_id is null then 1 else 0 end) as missing_category_id,
    sum(case when supplier_id is null then 1 else 0 end) as missing_supplier_id,
    sum(case when unit_price is null then 1 else 0 end) as missing_unit_price,
    sum(case when unit_cost is null then 1 else 0 end) as missing_unit_cost,
    sum(case when reorder_level is null then 1 else 0 end) as missing_reorder_level
from products;

-- ============================================================================
-- 6. MISSING VALUES CHECK IN STAFF TABLE
-- ============================================================================
select 
	sum(case when staff_id is null then 1 else 0 end) as missing_staff_id,
    sum(case when staff_name is null then 1 else 0 end) as missing_staff_name,
    sum(case when role is null then 1 else 0 end) as missing_role,
    sum(case when store_id is null then 1 else 0 end) as missing_store_id,
    sum(case when hire_date is null then 1 else 0 end) as missing_hire_date
from staff;


-- ============================================================================
-- 7. MISSING VALUES CHECK IN STORES TABLE
-- ============================================================================

select 
	sum(case when store_id is null then 1 else 0 end) as missing_store_id,
    sum(case when store_name is null then 1 else 0 end) as missing_store_name,
    sum(case when city is null then 1 else 0 end) as missing_city,
    sum(case when state is null then 1 else 0 end) as missing_state,
    sum(case when store_type is null then 1 else 0 end) as missing_store_type,
    sum(case when opening_date is null then 1 else 0 end) as missing_opening_date
from stores;

-- ============================================================================
-- 8. MISSING VALUES CHECK IN SUPPLIERS TABLE
-- ============================================================================

select 
	sum(case when supplier_id is null then 1 else 0 end) as missing_supplier_id,
    sum(case when supplier_name is null then 1 else 0 end) as missing_supplier_name,
    sum(case when supplier_region is null then 1 else 0 end) as missing_supplier_region,
    sum(case when payment_terms_days is null then 1 else 0 end) as missing_payment_terms_days
from suppliers;

-- ============================================================================
-- ============================================================================