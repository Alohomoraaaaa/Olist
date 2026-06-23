ALTER TABLE customers ADD PRIMARY KEY (customer_id);

ALTER TABLE orders ADD PRIMARY KEY (order_id);

ALTER TABLE products ADD PRIMARY KEY (product_id);a

ALTER TABLE sellers ADD PRIMARY KEY (seller_id);

ALTER TABLE category ADD PRIMARY KEY (product_category_name);

ALTER TABLE payments
ADD PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE items
ADD PRIMARY KEY (order_id, order_item_id);

INSERT INTO category
VALUES ('Unknown', 'Unknown');

ALTER TABLE orders
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE payments
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE reviews
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE items
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE items
ADD FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE items
ADD FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

SELECT DISTINCT p.product_category_name
FROM products p
LEFT JOIN category c
    ON p.product_category_name = c.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND c.product_category_name IS NULL;

INSERT INTO category VALUES
('pc_gamer', 'pc_gamer'),
('portateis_cozinha_e_preparadores_de_alimentos',
 'portateis_cozinha_e_preparadores_de_alimentos');
 
ALTER TABLE products
ADD FOREIGN KEY (product_category_name)
REFERENCES category(product_category_name);