-- Database Schema for E-Commerce Sales Intelligence
-- PostgreSQL

CREATE DATABASE ecommerce_sales;

\c ecommerce_sales;

-- Main orders table
CREATE TABLE orders (
    order_id        SERIAL PRIMARY KEY,
    order_date      DATE NOT NULL,
    customer_id     INT NOT NULL,
    region          VARCHAR(50) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    revenue         DECIMAL(10,2) NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_order_date ON orders(order_date);
CREATE INDEX idx_region ON orders(region);
CREATE INDEX idx_category ON orders(product_category);
CREATE INDEX idx_region_category ON orders(region, product_category);

-- View: Daily KPIs
CREATE VIEW daily_kpis AS
SELECT
    order_date,
    SUM(revenue) AS daily_revenue,
    COUNT(*) AS order_count,
    AVG(revenue) AS avg_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
GROUP BY order_date
ORDER BY order_date DESC;

-- View: Category Performance Daily
CREATE VIEW category_performance_daily AS
SELECT
    order_date,
    product_category,
    SUM(revenue) AS revenue,
    COUNT(*) AS order_count,
    AVG(revenue) AS avg_order_value
FROM orders
GROUP BY order_date, product_category
ORDER BY order_date DESC, revenue DESC;

-- View: Region Performance Daily
CREATE VIEW region_performance_daily AS
SELECT
    order_date,
    region,
    SUM(revenue) AS revenue,
    COUNT(*) AS order_count,
    AVG(revenue) AS avg_order_value
FROM orders
GROUP BY order_date, region
ORDER BY order_date DESC, revenue DESC;
