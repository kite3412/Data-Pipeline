{{ config(materialized='table', schema='star') }}

SELECT
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM order_payments
