SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'orders';

ALTER TABLE orders
ALTER COLUMN order_purchase_timestamp
TYPE TIMESTAMP
USING order_purchase_timestamp::TIMESTAMP;

ALTER TABLE orders
ALTER COLUMN order_approved_at
TYPE TIMESTAMP
USING NULLIF(order_approved_at, '')::TIMESTAMP;

ALTER TABLE orders
ALTER COLUMN order_delivered_carrier_date
TYPE TIMESTAMP
USING NULLIF(order_delivered_carrier_date, '')::TIMESTAMP;

ALTER TABLE orders
ALTER COLUMN order_delivered_customer_date
TYPE TIMESTAMP
USING NULLIF(order_delivered_customer_date, '')::TIMESTAMP;

ALTER TABLE orders
ALTER COLUMN order_estimated_delivery_date
TYPE TIMESTAMP
USING order_estimated_delivery_date::TIMESTAMP;