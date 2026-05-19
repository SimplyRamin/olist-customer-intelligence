SELECT
    order_id,
    product_id,
    seller_id,
    price,
    freight_value,
    price + freight_value AS order_item_value,
    freight_value / (price + freight_value) AS freight_ratio
FROM {{ source('olist', 'order_items') }}