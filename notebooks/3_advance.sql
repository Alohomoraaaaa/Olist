-- 1. How has Olist's revenue changed over time?
-- This helps identify growth, seasonality, and periods of decline.

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value)::numeric, 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- 2. Do delayed deliveries lead to poorer reviews?
-- Business goal: Understand whether delivery performance impacts customer satisfaction.

SELECT
    r.review_score,
    ROUND(
        AVG(
            EXTRACT(
                DAY FROM (
                    o.order_delivered_customer_date -
                    o.order_estimated_delivery_date
                )
            )
        )::numeric,
        2
    ) AS avg_delay_days,
    COUNT(*) AS total_orders
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

-- 3. Which sellers are top performers?
-- Business goal: Identify high-revenue sellers and compare their review performance.

SELECT
    i.seller_id,
    ROUND(SUM(p.payment_value)::numeric, 2) AS total_revenue,
    ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score,
    COUNT(DISTINCT o.order_id) AS total_orders,
    RANK() OVER (
        ORDER BY SUM(p.payment_value) DESC
    ) AS revenue_rank
FROM items i
JOIN orders o
    ON i.order_id = o.order_id
JOIN payments p
    ON o.order_id = p.order_id
JOIN reviews r
    ON o.order_id = r.order_id
GROUP BY i.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 4. RFM Analysis
-- Identify high-value customers based on Recency, Frequency, and Monetary value.

WITH latest_date AS (
    SELECT MAX(order_purchase_timestamp::date) AS max_date
    FROM orders
)

SELECT
    c.customer_unique_id,
    ld.max_date - MAX(o.order_purchase_timestamp::date) AS recency_days,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND(SUM(p.payment_value)::numeric, 2) AS monetary
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
CROSS JOIN latest_date ld
GROUP BY c.customer_unique_id, ld.max_date
ORDER BY monetary DESC
LIMIT 10;

-- 5. Customer Retention by First Purchase Month
-- Business goal: Do customers come back and purchase again?

WITH customer_cohort AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),

customer_orders AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)

SELECT
    cc.cohort_month,
    (
        EXTRACT(YEAR FROM age(co.order_month, cc.cohort_month)) * 12 +
        EXTRACT(MONTH FROM age(co.order_month, cc.cohort_month))
    ) AS months_since_first_purchase,
    COUNT(DISTINCT co.customer_unique_id) AS customers
FROM customer_cohort cc
JOIN customer_orders co
    ON cc.customer_unique_id = co.customer_unique_id
GROUP BY
    cc.cohort_month,
    months_since_first_purchase
ORDER BY
    cc.cohort_month,
    months_since_first_purchase;

-- 5. Overall Repeat Purchase Rate

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_count > 1) / COUNT(*),
        2
    ) AS repeat_purchase_rate
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t;

-- 6. Which product categories contribute the most revenue?
-- Business goal: Identify Olist's highest-value product categories.

SELECT
    c.product_category_name_english,
    ROUND(SUM(p.payment_value)::numeric, 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM products pr
JOIN category c
    ON pr.product_category_name = c.product_category_name
JOIN items i
    ON pr.product_id = i.product_id
JOIN orders o
    ON i.order_id = o.order_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY c.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- 7. Which payment methods contribute most to revenue?
-- Business goal: Understand customer payment preferences and their value.

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value)::numeric, 2) AS total_revenue,
    ROUND(AVG(payment_value)::numeric, 2) AS avg_order_value
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- 8. Which customer states contribute the most revenue?
-- Business goal: Identify Olist's strongest geographic markets.

SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value)::numeric, 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- 9. Which sellers have the worst customer ratings?
-- Business goal: Identify sellers hurting customer experience.

SELECT
    i.seller_id,
    ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM items i
JOIN orders o
    ON i.order_id = o.order_id
JOIN reviews r
    ON o.order_id = r.order_id
GROUP BY i.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 50
ORDER BY avg_review_score ASC, total_orders DESC
LIMIT 10;