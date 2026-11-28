-- ============================================================================
-- DATA QUALITY ASSESSMENT (RECONCILIATION)
-- DATE: 26/11/2026.
-- ============================================================================

-- ============================================================================
-- 1. ORDER ITEMS ROW COUNT RECONCIIATION
-- ============================================================================

select
	count(*) as total_order_items
from order_items;

-- This confirms the current order items table contains 4,155 records.

-- ============================================================================
-- 2. COMPOSITE-KEY DUPLICATES VERIFICATION
-- ============================================================================

select
	order_id,
    line_number,
    count(*) as duplicate_count
from order_items
group by order_id, line_number
having count(*) > 1;

-- Two records share the same order_id and line_number

-- ============================================================================
-- 3. RETRIEVE THE DUPLICATE RECORDS
-- ============================================================================

select *
from order_items 
where order_id = 'ORD000033'
	and line_number = 1;

-- The two returned records are exact duplicates 
-- The order_items table contains two identical records for the same order line

-- ============================================================================
-- 4. CHECK THE IMPACT ON THE ORDER
-- ============================================================================

select *
from orders
where order_id = 'ORD000033';

-- The duplicate order item records belong to an order marked 'Returned'.
-- Both records contain exactly the same product, quantity, price and discount

-- ============================================================================
-- 5. INVESTIGATE THE ORDER'S COMPLETE LINE ITEMS
-- ============================================================================

select 
	oi.order_id,
    oi.line_number,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
from order_items as oi
left join products as p
	on oi.product_id = p.product_id
where oi.order_id = 'ORD000033'
order by oi.line_number;

-- This confirms that ORD000033 contains only two identical records for 
-- line number 1. There are no other line items for this order

-- ============================================================================
-- 6. FINAL IMPACT CHECK
-- ============================================================================

select
	order_id,
    sum(quantity) as total_quantity,
    sum(quantity * unit_price * (1 -discount_pct)) as total_line_value
from order_items 
where order_id = 'ORD000033'
group by order_id;

-- ============================================================================
-- 7. INVESTIGATE ORD001731
-- ============================================================================

-- Retreive the complete order details

select
	o.order_id,
    o.order_date,
    o.customer_id,
    o.store_id,
    o.staff_id,
    o.sales_channel,
    o.payment_method,
    o.order_status,
    oi.line_number,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where o.order_id = 'ORD001731';

-- The result shows that ORD001731 contains just one order item, and that
-- item has a quantity of -2.

-- ============================================================================
-- 8. INVESTIGATE THE CUSTOMER'S OTHER TRANSACTION
-- ============================================================================

-- check to see whether the customer with the negative quantity has other 
-- transactions

select 
	o.order_id,
    o.order_date,
    o.order_status,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id 
where o.customer_id = 'C0155'
order by o.order_date;

-- This query is to investigate if there is any related transactions,
-- particularly another purchase or return involving P0021 (Bleach 1L)
-- This query result shows that:
-- Customer (C0155) has several transactions between March 2025 and 
-- September 2026.

-- ============================================================================
-- 9. CHECK WHETHER THE PRODUCTS APPEAR IN OTHER TRANSACTIONS
-- ============================================================================

select 
	o.order_id,
    o.order_date,
    o.customer_id,
    o.order_status,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
where oi.product_id = 'P0021'
order by o.order_date;

-- From the transaction history
-- The product has numerous transactions with positive quantities.
-- The only negative quantity is -2 in ORD001731

-- ============================================================================
-- 9. CHECK ALL NEGATIVE QUANTITIES ACROSS THE DATASET
-- ============================================================================
-- check to determine whether ORD001731 is the only negative-quantity trans
-- action or whether there are other examples.

select
	o.order_id,
    o.order_date,
    o.order_status,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where oi.quantity < 0
order by o.order_date;

-- The query confirms that only ORD001731 is the only transaction with a 
-- negative quantity in the current dataset.

-- ============================================================================
-- 10. INVESTIGATE THE ZERO QUANTITY RECORD
-- ============================================================================

select 
	o.order_id,
    o.order_date,
    o.customer_id,
    o.store_id,
    o.staff_id,
    o.sales_channel,
    o.payment_method,
    o.order_status,
    oi.line_number,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where o.order_id = 'ORD002194';

-- From the query
-- This order contains three different product lines, and only one has an anomalous
-- quantity (zero quantity). and shows that order was completed.

-- ============================================================================
-- 11. CHECK TO SEE IF ANY OTHER ORDER ITEM RECORDS HAVE ZERO QUANTITIES
-- ============================================================================

select
	o.order_id,
    o.order_date,
    o.order_status,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where oi.quantity = 0
order by o.order_date;

-- ============================================================================
-- 12. CHECK THE TOTAL QUANTITY ANOMALIES TOGETHER
-- ============================================================================

select
	count(*) as total_records,
    sum(case when quantity < 0 then 1 else 0 end) as negative_quantity_records,
    sum(case when quantity = 0 then 1 else 0 end) as zero_quantity_records,
    sum(case when quantity > 0 then 1 else 0 end) as positive_quantity_records
from order_items;

-- ============================================================================
-- 13. VALIDATE THE REMAINING NUMERICAL FIELDS (REORDER_LEVEL COLUMN)
-- ============================================================================

-- check to see if any product has an invalid reorder level.

select
	product_id,
    product_name,
    reorder_level
from products
where reorder_level < 0;

-- It returned no record

-- ============================================================================
-- 14. VALIDATE THE  PAYMENT TERMS DAYS COLUMNS FROM SUPPLIERS TABLE
-- ============================================================================

select
	supplier_id,
    supplier_name,
    payment_terms_days
from suppliers
where payment_terms_days < 0;

-- It returned no record

-- ============================================================================
-- 15. DISCOUNT VALIDATION
-- ============================================================================

select
    order_id,
    line_number,
    product_id,
    quantity,
    unit_price,
    discount_pct
from order_items
where discount_pct < 0
   or discount_pct > 1
order by order_id;

-- The discount pct from the returned query is 120% discount.
-- Therefore this needs to be investigated.

-- To confirm the distribution of account values:

select 
	discount_pct,
    count(*) as total_records
from order_items
group by discount_pct
order by discount_pct;

-- Eight records have a discount of 120% 
-- The other 4,147 records fall within the expected range
-- All eight anomalous records belong to orders marked completed.