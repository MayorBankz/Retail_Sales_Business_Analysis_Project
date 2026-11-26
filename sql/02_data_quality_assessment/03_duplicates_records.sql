-- ============================================================================
-- DATA QUALITY ASSESSMENT (DUPLICATE RECORDS ASSESSMENT)
-- DATE: 18//11/2026.
-- ============================================================================

-- ============================================================================
-- 	1. CUSTOMERS TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select
	customer_id,
    count(*) as customer_count
from customers
group by customer_id
having count(*) > 1;

-- ============================================================================
-- 	2. CATEGORIES TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select 
	category_id,
    count(*) as category_count
from categories
group by category_id
having count(*) > 1
;

-- ============================================================================
-- 	3. PRODUCTS TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select 
	product_id,
    count(*) as products_count
from products
group by product_id
having count(*) > 1
;

-- ============================================================================
-- 	4. SUPPLIERS TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select 
	supplier_id,
    count(*) as suppliers_count
from suppliers
group by supplier_id
having count(*) > 1;

-- ============================================================================
-- 	5. STAFF TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select 
	staff_id,
    count(*) as staffs_count
from staff
group by staff_id
having count(*) > 1;

-- ============================================================================
-- 	6. STORE TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select
	store_id,
    count(*) as store_count
from stores
group by store_id
having count(*) > 1;

-- ============================================================================
-- 	7. ORDERS TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select
	order_id,
    count(*) as order_count
from orders
group by order_id
having count(*) > 1;

-- ============================================================================
-- 	8. ORDER ITEMS TABLE CHECK FOR DUPLICATES 
-- ============================================================================

select  
	order_id,
    line_number,
    count(*) as order_items_counts
from order_items
group by order_id, line_number
having count(*) > 1;

-- means there is a duplicate

-- ============================================================================
-- INVESTIGATE THE DUPLICATE RECORD
-- ============================================================================








