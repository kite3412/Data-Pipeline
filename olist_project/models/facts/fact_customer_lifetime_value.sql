{{ config(materialized='table', schema="star") }}

WITH customer_sales AS (
    SELECT
        dc.customer_key,
        SUM(fs.total_sale_amount) AS lifetime_sales
    FROM {{ ref('fact_sales') }} fs
    LEFT JOIN {{ ref('dim_customer') }} dc
      ON fs.customer_key = dc.customer_key
    GROUP BY dc.customer_key
)
SELECT
    customer_key,
    lifetime_sales,
    CASE 
       WHEN lifetime_sales < 100 THEN 'Low'
       WHEN lifetime_sales BETWEEN 100 AND 500 THEN 'Medium'
       ELSE 'High'
    END AS customer_value_segment
FROM customer_sales
