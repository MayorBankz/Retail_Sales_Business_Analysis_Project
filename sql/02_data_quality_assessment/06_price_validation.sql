-- ============================================================================
-- DATA QUALITY ASSESSMENT (PRICE VALIDATION)
-- DATE: 25/11/2026.
-- ============================================================================

-- ============================================================================
-- What to investigate
-- Differences between order_items.unit_price and products.unit_price
-- Products sold below their reference cost
-- Unusually high or low transaction prices.
-- Missing or inconsistent price records.
-- ============================================================================

-- ============================================================================
-- Important distinction
-- products.unit_price is the product's reference selling price
-- products.unit_cost is the product's reference cost.
-- order_items.unit_price is the actual price recorded for a transaction.
-- ============================================================================

-- ============================================================================
-- 1.0 Compare transaction prices with reference prices
-- ============================================================================

with price_difference as (
select
	oi.order_id,
    p.product_id,
    p.product_name,
    oi.unit_price as transaction_price,
    p.unit_price as reference_price
from order_items as oi
join products as p
	on oi.product_id = p.product_id
where oi.unit_price <> p.unit_price
)
select 
	*,
	((transaction_price - reference_price) / reference_price) * 100
    as price_difference_pct
from price_difference;

-- Positive percentage = transaction price is higher than reference price
-- Negative percentage = transaction price is lower than reference price
-- Zero percentage = both prices are equal

-- ============================================================================
-- 2.0 CHECK TO SEE IF THE PRICE DIFFERENCES ARE LINKED TO DISCOUNTS
-- ============================================================================

with price_difference as (
select
	oi.order_id,
    p.product_id,
    p.product_name,
    oi.unit_price as transaction_price,
    p.unit_price as reference_price,
    oi.discount_pct,
    oi.quantity
from order_items as oi
join products as p
	on oi.product_id = p.product_id
where oi.unit_price <> p.unit_price
)
select 
	*,
	((transaction_price - reference_price) / reference_price) * 100
    as price_difference_pct
from price_difference;

-- There are 19 records with price differences
-- 8 transactions have a 15% higher transaction price
-- 11 transactions have a 15% lower transaction price.
-- This means we cannot assume that the transaction price difference is 
-- caused by the discount


-- ============================================================================
-- 3.0 VERIFY THE RELATIONSHIP BETWEEN TRANSACTION PRICE AND DISCOUNT
-- ============================================================================

with price_difference as (
select
	oi.order_id,
    p.product_id,
    p.product_name,
    oi.unit_price as transaction_price,
    p.unit_price as reference_price,
    oi.discount_pct,
    oi.quantity
from order_items as oi
join products as p
	on oi.product_id = p.product_id
where oi.unit_price <> p.unit_price
)
select 
	*,
	((transaction_price - reference_price) / reference_price) * 100
    as price_difference_pct,
    (reference_price * (1 - discount_pct)) as expected_price
from price_difference;

-- Of the 19 records
-- 2 match the expected price exactly
-- 17 do not match
-- What this means (three possible explanations)
-- 1. Some transaction prices were adjusted before discounts were applied
-- 2. Some prices were changed independently of the discount.
-- 3. Some transaction prices may contain data-entry or pricing errors.

-- ============================================================================
-- 4.0 CHECK TRANSACTION PRICES AGAINST PRODUCT COSTS
-- ============================================================================

-- Investigate whether any products were sold below their reference cost.

with price_difference as (
select
	oi.order_id,
    p.product_id,
    p.product_name,
    oi.unit_price as transaction_price,
    p.unit_price as reference_price,
    p.unit_cost as unit_cost,
    oi.discount_pct,
    oi.quantity
from order_items as oi
join products as p
	on oi.product_id = p.product_id
)
select 
	*,
	((transaction_price - reference_price) / reference_price) * 100
    as price_difference_pct,
    (reference_price * (1 - discount_pct)) as expected_price
from price_difference
where transaction_price < unit_cost;

-- no record was returned, which means:
-- no transaction prices were below their corresponding product reference costs.

-- ============================================================================
-- 5.0 IDENTIFY UNUSUALLY HIGH TRANSACTION PRICES
-- ============================================================================

-- check to see whether any transaction prices are highly than the reference
-- selling prices

with price_comparison as (
select
	oi.order_id,
    p.product_id,
    p.product_name,
    oi.unit_price as transaction_price,
    p.unit_price as reference_price,
    case
		when oi.unit_price > p.unit_price then 'Higher than reference price'
        when oi.unit_price < p.unit_price then 'Lower than reference price'
        else 'Equal to reference price'
	end as price_category
from order_items as oi
join products as p
	on oi.product_id = p.product_id
) 
select
	price_category,
    count(*) as record_count
from price_comparison
group by price_category
order by record_count desc;

-- Interpretation
-- most transaction prices (99.54%) match the product reference prices.
-- Only 19 records (0.46%) have different transaction prices
-- All 19 differences are exactly 15%: 11 lower and 8 higher

-- ============================================================================
-- 6.0 VERIFY MISSING TRANSACTION PRICES
-- ============================================================================

-- check to see whether any transaction prices are missing.

select
	count(*) as missing_price_records
from order_items
where unit_price is null;

-- ============================================================================
-- 7.0 MISSING PRODUCT REFERENCE PRICES
-- ============================================================================

select
	count(*) as missing_reference_prices
from products
where unit_price is null;