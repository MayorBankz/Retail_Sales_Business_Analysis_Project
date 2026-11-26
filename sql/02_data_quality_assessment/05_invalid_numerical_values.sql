-- ============================================================================
-- DATA QUALITY ASSESSMENT (INVALID NUMERICAL VALUES)
-- DATE: 23/11/2026.
-- ============================================================================

-- ============================================================================
-- 1.0 CHECK FOR ZERO AND NEGATIVE QUANTITIES IN ORDER ITEMS TABLE
-- ============================================================================

select
	order_id,
    line_number,
    product_id,
    quantity
from order_items
where quantity = 0 or quantity < 0;

-- -2 is invalid for a normal retail sale quantity
-- 0 indicates that no units were recorded for the transaction line.

-- ============================================================================
-- 1.1 INVESTIGATE THE AFFECTED ORDER RECORDS 
-- ============================================================================

select 
	oi.order_id,
    oi.line_number,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct,
    o.order_date,
    o.order_status
from order_items as oi
join products as p
	on oi.product_id = p.product_id
join orders as o
	on oi.order_id = o.order_id
where oi.quantity <= 0;

-- ============================================================================
-- 2.0 CHECK FOR INVALID UNIT PRICES IN ORDER ITEMS TABLE
-- ============================================================================

select
	order_id,
    line_number,
    product_id,
    unit_price
from order_items
where unit_price = 0 or unit_price < 0;

-- ============================================================================
-- 3.0 CHECK FOR INVALID UNIT PRICES IN PRODUCTS TABLE
-- ============================================================================

select
	product_id,
    product_name,
    unit_price
from products
where unit_price = 0 or unit_price < 0;

-- ============================================================================
-- 4.0 CHECK FOR INVALID UNIT COST IN PRODUCTS TABLE
-- ============================================================================

select 
	product_id,
    product_name,
    unit_cost
from products
where unit_cost = 0 or unit_cost < 0;

-- ============================================================================
-- 5.0 CHECK FOR INVALID UNIT COST IN PRODUCTS TABLE
-- ============================================================================

select 
	product_id,
    product_name,
    reorder_level
from products
where reorder_level = 0 or reorder_level < 0;

-- ============================================================================
-- 5.0 CHECK FOR INVALID PAYMENT TERMS DAY IN SUPPLIERS TABLE
-- ============================================================================

select 
	supplier_id,
    supplier_name,
    payment_terms_days
from suppliers
where payment_terms_days = 0 or payment_terms_days < 0;

-- ============================================================================
-- 5.0 CHECK FOR UNUSUALLY LARGE QUANTITES IN ORDER ITEM TABLE
-- ============================================================================

select max(quantity) as maximum_quantity
from order_items;

-- ============================================================================
-- 6.0 CHECK INVALID DISCOUNT PCT IN ORDER ITEM TABLE
-- ============================================================================

select
	order_id,
    line_number,
    product_id,
    discount_pct
from order_items
where discount_pct < 0 or discount_pct >1;

-- ============================================================================
-- 6.1 INVESTIGATE THE INVALID DISCOUNT PCT IN ORDER ITEM TABLE
-- ============================================================================

select
	oi.order_id,
    oi.line_number,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct,
    o.order_date,
    o.order_status
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
where discount_pct > 1;

-- ============================================================================
-- 6.2 CHECK THE DISCOUNT DISTRIBUTION
-- ============================================================================

select 
	discount_pct,
    count(*) as record_count
from order_items
group by discount_pct
order by discount_pct;

-- shows that all values fall between 0 and 0.20
-- Eight records contain 1.2, which is outside the expected range
-- The eight records represent approximately 0.19% of the 4,155 records with a
-- discount value.

-- ============================================================================
-- 6.3 CHECK THE MISSING DISCOUNTS
-- ============================================================================

-- verify whether any discount_pct values are null
select
	discount_pct
from order_items
where discount_pct is null;
