-- ============================================================================
-- DATA QUALITY ASSESSMENT (DISCOUNT VALIDATION)
-- DATE: 26/11/2026.
-- ============================================================================

-- ============================================================================
-- 1.0 CHECK DISCOUNTS BELOW ZERO OR ABOVE 100%
-- ============================================================================

-- Identify invalid discount percentages

select
	order_id,
    line_number,
    product_id,
    discount_pct
from order_items
where discount_pct < 0
	or discount_pct > 1;
    
-- all eight records had a discount of 1.2 (120%)

-- ============================================================================
-- 2.0 CHECK DISCOUNT DISTRIBUTION
-- ============================================================================

-- Examine the distribution of discount values

select
	discount_pct,
    count(*) as record_count
from order_items
group by discount_pct
order by discount_pct;

-- ============================================================================
-- 3.0 CHECK FOR MISSING DISCOUNTS
-- ============================================================================

-- Identify missing discount values

select
	count(*) as missing_discount_records
from order_items
where discount_pct is null;

-- 0 missing records

-- ============================================================================
-- 4.0 INVESTIGATE AFFECTED TRANSACTIONS
-- ============================================================================

-- Retrieve transaction details for invalid discounts

select
	oi.order_id,
    oi.line_number,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct,
    o.order_date,
    o.order_status
from order_items as oi
join orders as o
	on oi.order_id = o.order_id
where oi.discount_pct > 1;

-- All eight affected transactions had a completed status.

