-- Anomaly Detection Rules for E-Commerce Sales Intelligence
-- Rule-Based Statistical Anomaly Detection

-- Anomaly Detection: Revenue Drops and Spikes
-- Detects daily revenue that deviates significantly from 7-day moving average

WITH daily_metrics AS (
    SELECT
        order_date,
        SUM(revenue) AS daily_revenue,
        COUNT(*) AS daily_orders,
        AVG(revenue) AS daily_aov
    FROM orders
    GROUP BY order_date
),
with_moving_avg AS (
    SELECT
        order_date,
        daily_revenue,
        daily_orders,
        daily_aov,
        -- 7-day moving average (excluding current day)
        AVG(daily_revenue) OVER (
            ORDER BY order_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS ma_7d_revenue,
        AVG(daily_orders) OVER (
            ORDER BY order_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS ma_7d_orders
    FROM daily_metrics
),
anomalies AS (
    SELECT
        order_date,
        daily_revenue,
        ma_7d_revenue,
        daily_orders,
        ma_7d_orders,
        -- Calculate deviation percentage
        ROUND(
            ((daily_revenue - ma_7d_revenue) / NULLIF(ma_7d_revenue, 0)) * 100,
            2
        ) AS revenue_deviation_pct,
        ROUND(
            ((daily_orders - ma_7d_orders) / NULLIF(ma_7d_orders, 0)) * 100,
            2
        ) AS orders_deviation_pct,
        -- Classify anomaly type
        CASE
            WHEN daily_revenue < ma_7d_revenue * 0.7 THEN 'REVENUE_DROP'
            WHEN daily_revenue > ma_7d_revenue * 1.5 THEN 'REVENUE_SPIKE'
            ELSE NULL
        END AS revenue_anomaly_type,
        CASE
            WHEN daily_orders < ma_7d_orders * 0.7 THEN 'ORDERS_DROP'
            WHEN daily_orders > ma_7d_orders * 1.5 THEN 'ORDERS_SPIKE'
            ELSE NULL
        END AS orders_anomaly_type
    FROM with_moving_avg
    WHERE ma_7d_revenue IS NOT NULL  -- Need at least 7 days of history
)
SELECT
    order_date,
    daily_revenue,
    ma_7d_revenue,
    revenue_deviation_pct,
    revenue_anomaly_type,
    daily_orders,
    ma_7d_orders,
    orders_deviation_pct,
    orders_anomaly_type,
    -- Overall severity
    CASE
        WHEN ABS(revenue_deviation_pct) > 50 OR ABS(orders_deviation_pct) > 50 THEN 'CRITICAL'
        WHEN ABS(revenue_deviation_pct) > 30 OR ABS(orders_deviation_pct) > 30 THEN 'HIGH'
        ELSE 'MEDIUM'
    END AS severity
FROM anomalies
WHERE revenue_anomaly_type IS NOT NULL
   OR orders_anomaly_type IS NOT NULL
ORDER BY order_date DESC;

-- Category-Level Anomaly Detection
-- Detects when specific categories show unusual performance

WITH category_daily AS (
    SELECT
        order_date,
        product_category,
        SUM(revenue) AS category_revenue,
        COUNT(*) AS category_orders
    FROM orders
    GROUP BY order_date, product_category
),
category_ma AS (
    SELECT
        order_date,
        product_category,
        category_revenue,
        AVG(category_revenue) OVER (
            PARTITION BY product_category
            ORDER BY order_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS ma_7d_category
    FROM category_daily
)
SELECT
    order_date,
    product_category,
    category_revenue,
    ma_7d_category,
    ROUND(
        ((category_revenue - ma_7d_category) / NULLIF(ma_7d_category, 0)) * 100,
        2
    ) AS deviation_pct,
    CASE
        WHEN category_revenue < ma_7d_category * 0.5 THEN 'CATEGORY_COLLAPSE'
        ELSE 'CATEGORY_SURGE'
    END AS anomaly_type
FROM category_ma
WHERE ma_7d_category IS NOT NULL
  AND (
      category_revenue < ma_7d_category * 0.5  -- 50% drop
      OR category_revenue > ma_7d_category * 2.0  -- 100% spike
  )
ORDER BY order_date DESC, deviation_pct ASC;

-- Summary: Count of Anomalies by Type
SELECT
    revenue_anomaly_type,
    COUNT(*) AS anomaly_count
FROM (
    -- Same anomaly detection logic as above, simplified for summary
    SELECT
        order_date,
        CASE
            WHEN daily_revenue < ma_7d_revenue * 0.7 THEN 'REVENUE_DROP'
            WHEN daily_revenue > ma_7d_revenue * 1.5 THEN 'REVENUE_SPIKE'
            ELSE NULL
        END AS revenue_anomaly_type
    FROM (
        SELECT
            order_date,
            SUM(revenue) AS daily_revenue,
            AVG(SUM(revenue)) OVER (
                ORDER BY order_date
                ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
            ) AS ma_7d_revenue
        FROM orders
        GROUP BY order_date
    ) sub
    WHERE ma_7d_revenue IS NOT NULL
) anomalies
WHERE revenue_anomaly_type IS NOT NULL
GROUP BY revenue_anomaly_type;
