-- models/intermediate/int_customer_orders.sql
-- joins customer and order data, one row per order

SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.delivery_delay_days,
    c.customer_unique_id,
    c.customer_state,
    SUM(oi.order_item_value)        AS order_value,
    SUM(oi.freight_ratio)           AS avg_freight_ratio,
    COUNT(DISTINCT oi.product_id)   AS unique_products,
    COUNT(DISTINCT oi.seller_id)    AS unique_sellers
FROM {{ ref('stg_orders') }} o
JOIN {{ ref('stg_customers') }} c ON o.customer_id = c.customer_id
JOIN {{ ref('stg_order_items') }} oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_purchase_timestamp,
    o.delivery_delay_days,
    c.customer_unique_id,
    c.customer_state
