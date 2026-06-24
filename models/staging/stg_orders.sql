-- Staging: 1:1 with raw.orders — rename to snake_case, cast types.
with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        id                       as order_id,
        customer_id,
        lower(status)            as status,
        cast(amount as numeric)  as amount,
        cast(created_at as timestamp) as ordered_at,
        _airbyte_extracted_at    as loaded_at
    from source
)

select * from renamed
