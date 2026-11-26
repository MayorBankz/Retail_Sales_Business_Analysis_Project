
-- ============================================================================
-- EXPECTED RELATIONSHIP: One customer can place multiple orders.
-- ============================================================================

select *
from orders as o 
left join customers as c 
	on o.customer_id = c.customer_id
where c.customer_id is null;

-- ============================================================================
-- EXPECTED RELATIONSHIP: One store can be associated with multiple orders.
-- ============================================================================

select *
from orders as o
left join stores as s
	on o.store_id = s.store_id
where s.store_id is null;

-- ============================================================================
-- EXPECTED RELATIONSHIP: One staff member can handle multiple orders.
-- ============================================================================

select *
from orders as o
left join staff as s
	on o.staff_id = s.staff_id
where s.staff_id is null;

-- ============================================================================
-- EXPECTED RELATIONSHIP: One product can appear in multiple order items.
-- ============================================================================

select * 
from order_items as oi
left join products as p
	on oi.product_id = p.product_id
where p.product_id is null;

-- ============================================================================
-- EXPECTED RELATIONSHIP: One category can contain multiple products.
-- ============================================================================

select *
from products as p
left join categories as c
	on p.category_id = c.category_id
where c.category_id is null;

-- ============================================================================
-- EXPECTED RELATIONSHIP: One order can contain multiple order items.
-- ============================================================================

select *
from order_items as oi
left join orders as o
	on o.order_id = oi.order_id
where o.order_id is null 
;

-- ============================================================================
-- EXPECTED RELATIONSHIP: One supplier can supply mutliple products.
-- ============================================================================

select *
from products as p
left join suppliers as s
	on p.supplier_id = s.supplier_id
where s.supplier_id is null
;

-- ============================================================================
-- EXPECTED RELATIONSHIP: One store can have multiple staff members.
-- ============================================================================

select *
from staff as s
left join stores as st
	on s.store_id = st.store_id
where st.store_id is null
;
-- ============================================================================