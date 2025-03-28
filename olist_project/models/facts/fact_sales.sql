{{ config(materialized='table', schema='star') }}

WITH orders_data AS (
    SELECT
        order_id,
        customer_id,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date
    FROM {{ ref('stg_orders') }}
    WHERE order_delivered_customer_date IS NOT NULL
),
order_items_data AS (
    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        price,
        freight_value
    FROM {{ ref('stg_order_items') }}
),
order_payments_data AS (
    SELECT
        order_id,
        MIN(
            CASE
                WHEN LOWER(payment_type) IN ('boleto', 'credit_card', 'debit_card', 'voucher')
                    THEN LOWER(payment_type)
                ELSE 'credit_card'
            END
        ) AS payment_type,
        SUM(payment_installments) AS total_installments,
        SUM(payment_value) AS total_payment_value
    FROM {{ ref('stg_order_payments') }}
    GROUP BY order_id
),
joined_data AS (
    SELECT
        o.order_id,
        oi.order_item_id,
        o.customer_id,
        oi.product_id,
        oi.seller_id,
        o.order_purchase_timestamp,
        o.order_approved_at,
        o.order_delivered_carrier_date,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        oi.price,
        oi.freight_value,
        (oi.price + oi.freight_value) AS total_sale_amount
    FROM orders_data o
    INNER JOIN order_items_data oi
      ON o.order_id = oi.order_id
)
SELECT
    jd.order_id,
    jd.order_item_id,
    dc.customer_key,                    -- Join to DimCustomer
    dp.product_key,                     -- Join to DimProduct
    dd.date_key AS order_date_key,      -- Join to DimDate
    jd.order_purchase_timestamp,
    jd.order_approved_at,
    jd.order_delivered_carrier_date,
    jd.order_delivered_customer_date,
    jd.order_estimated_delivery_date,
    jd.price,
    jd.freight_value,
    jd.total_sale_amount,
    -- Ensure payment_type is always one of the allowed values and not NULL:
    COALESCE(
        CASE
            WHEN op.payment_type IS NOT NULL 
                 AND TRIM(LOWER(op.payment_type)) IN ('boleto', 'credit_card', 'debit_card', 'voucher')
            THEN TRIM(LOWER(op.payment_type))
            ELSE 'credit_card'
        END,
        'credit_card'
    ) AS payment_type,
    op.total_installments,
    op.total_payment_value
FROM joined_data jd
LEFT JOIN {{ ref('dim_customer') }} dc
  ON jd.customer_id = dc.customer_id
LEFT JOIN {{ ref('dim_product') }} dp
  ON jd.product_id = dp.product_id
LEFT JOIN {{ ref('dim_date') }} dd
  ON CAST(jd.order_purchase_timestamp AS DATE) = dd.date
LEFT JOIN order_payments_data op
  ON jd.order_id = op.order_id

