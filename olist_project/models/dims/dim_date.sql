{{ config(materialized='table', schema="star") }}

WITH date_series AS (
    SELECT
        d::DATE AS date
    FROM
        generate_series(DATE '2016-01-01', DATE '2022-12-31', INTERVAL '1 day') AS t(d)
)
SELECT
    CAST(STRFTIME(date, '%Y%m%d') AS INTEGER) AS date_key,
    date,
    CAST(STRFTIME(date, '%d') AS INTEGER) AS day,
    CAST(STRFTIME(date, '%m') AS INTEGER) AS month,
    CAST(STRFTIME(date, '%Y') AS INTEGER) AS year,
    STRFTIME(date, '%w') AS day_of_week,
    CASE WHEN STRFTIME(date, '%w') IN ('0', '6') THEN 'Y' ELSE 'N' END AS is_weekend
FROM date_series
