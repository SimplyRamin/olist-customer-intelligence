-- models/marts/customer_features.sql
-- Final customer-level feature table ready for ML
-- Materialized as a table (not view) for performance

{{ config(materialized='table') }}

SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id)                    AS total_orders,
    SUM(order_value)                            AS total_spent,
    AVG(order_value)                            AS avg_order_value,
    MIN(order_purchase_timestamp)               AS first_order_date,
    MAX(order_purchase_timestamp)               AS last_order_date,
    AVG(avg_freight_ratio)                      AS avg_freight_ratio,
    AVG(delivery_delay_days)                    AS avg_delivery_delay_days,
    AVG(CASE WHEN delivery_delay_days > 0
        THEN 1.0 ELSE 0 END)                    AS late_delivery_rate,
    SUM(unique_products)                        AS total_unique_products,
    COUNT(DISTINCT customer_state)              AS states_ordered_from,
    DATEDIFF('day',
        MAX(order_purchase_timestamp),
        (SELECT MAX(order_purchase_timestamp)
         FROM {{ ref('int_customer_orders') }})
    )                                           AS recency_days,
    DATEDIFF('day',
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))          AS customer_lifespan_days
FROM {{ ref('int_customer_orders') }}
GROUP BY customer_unique_id