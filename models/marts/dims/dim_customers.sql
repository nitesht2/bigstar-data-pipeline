-- Dimension: one row per customer enriched with lifetime order metrics.
with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_orders as (
    select
        customer_id,
        count(*)         as lifetime_orders,
        sum(amount)      as lifetime_value,
        min(ordered_at)  as first_order_at,
        max(ordered_at)  as most_recent_order_at
    from orders
    where status not in ('cancelled', 'returned')
    group by customer_id
)

select
    c.customer_id,
    c.email,
    c.first_name,
    c.last_name,
    c.created_at,
    coalesce(co.lifetime_orders, 0) as lifetime_orders,
    coalesce(co.lifetime_value, 0)  as lifetime_value,
    co.first_order_at,
    co.most_recent_order_at
from customers c
left join customer_orders co using (customer_id)
