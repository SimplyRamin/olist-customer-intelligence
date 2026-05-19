-- models/staging/stg_orders.sql
-- Cleans and standardizes the raw orders table

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    DATEDIFF('day',
        order_delivered_customer_date,
        order_estimated_delivery_date
    ) AS delivery_delay_days
FROM {{ source('olist', 'orders') }}
WHERE order_status = 'delivered'