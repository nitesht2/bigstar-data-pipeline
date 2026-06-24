-- Staging: 1:1 with raw.customers — rename to snake_case, cast types, light clean.
with source as (
    select * from {{ source('raw', 'customers') }}
),

renamed as (
    select
        id                      as customer_id,
        lower(email)            as email,
        first_name,
        last_name,
        cast(created_at as timestamp) as created_at,
        _airbyte_extracted_at   as loaded_at
    from source
    -- When syncing with Airbyte CDC, soft-deleted rows carry a deletion stamp.
    -- Uncomment to exclude them once the column is present:
    -- where _ab_cdc_deleted_at is null
)

select * from renamed
