-- Fact: order-grain table, loaded incrementally so refreshes only process new rows.
{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}

    {% if is_incremental() %}
    -- Only pull rows newer than the latest already loaded into this table.
    where loaded_at > (select max(loaded_at) from {{ this }})
    {% endif %}
)

select
    order_id,
    customer_id,
    status,
    amount,
    ordered_at,
    loaded_at
from orders
