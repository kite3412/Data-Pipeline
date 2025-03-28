{{ config(materialized='table', schema="star") }}

SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix AS zip_code,
    customer_city AS city,
    customer_state AS state
FROM customers
