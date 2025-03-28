{{ config(materialized='table', schema="star") }}

SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
    customer_id,
    customer_unique_id,
    TRIM(city) AS city,
    TRIM(state) AS state,
    CAST(zip_code AS INTEGER) AS zip_code
FROM {{ ref('stg_customers') }}
