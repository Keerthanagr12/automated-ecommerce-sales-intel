-- Sample Data for E-Commerce Sales Intelligence Project
-- 3-6 months of realistic sales data with intentional anomalies

-- Insert sample data
INSERT INTO orders (order_date, customer_id, region, product_category, quantity, revenue) VALUES
-- January data (normal baseline)
('2025-01-01', 1001, 'North', 'Electronics', 2, 159.99),
('2025-01-01', 1002, 'South', 'Fashion', 1, 89.50),
('2025-01-01', 1003, 'East', 'Home', 3, 249.99),
('2025-01-02', 1004, 'West', 'Beauty', 1, 49.99),
('2025-01-02', 1005, 'North', 'Electronics', 1, 129.99),
('2025-01-02', 1006, 'South', 'Fashion', 2, 159.98),
('2025-01-03', 1007, 'East', 'Home', 1, 79.99),
('2025-01-03', 1008, 'West', 'Beauty', 2, 99.98),
('2025-01-03', 1009, 'North', 'Electronics', 1, 199.99),
('2025-01-04', 1010, 'South', 'Fashion', 3, 269.97),
('2025-01-04', 1011, 'East', 'Home', 2, 159.98),
('2025-01-04', 1012, 'West', 'Beauty', 1, 59.99),
('2025-01-05', 1013, 'North', 'Electronics', 2, 299.98),
('2025-01-05', 1014, 'South', 'Fashion', 1, 79.99),
('2025-01-05', 1015, 'East', 'Home', 3, 299.97),
-- ANOMALY 1: January 15 - Revenue drops 60% (system downtime)
('2025-01-15', 1016, 'North', 'Electronics', 1, 50.00),
('2025-01-15', 1017, 'South', 'Fashion', 1, 40.00),
-- Normal recovery
('2025-01-16', 1018, 'East', 'Home', 2, 199.98),
('2025-01-16', 1019, 'West', 'Beauty', 3, 149.97),
('2025-01-17', 1020, 'North', 'Electronics', 2, 259.98),
-- February data (normal)
('2025-02-01', 1021, 'South', 'Fashion', 1, 99.99),
('2025-02-01', 1022, 'East', 'Home', 2, 179.98),
('2025-02-02', 1023, 'West', 'Beauty', 1, 69.99),
('2025-02-02', 1024, 'North', 'Electronics', 3, 389.97),
('2025-02-03', 1025, 'South', 'Fashion', 2, 179.98),
('2025-02-03', 1026, 'East', 'Home', 1, 89.99),
('2025-02-04', 1027, 'West', 'Beauty', 2, 119.98),
('2025-02-04', 1028, 'North', 'Electronics', 1, 179.99),
-- ANOMALY 2: February 10-12 - Revenue spikes 150% (flash sale)
('2025-02-10', 1029, 'South', 'Fashion', 5, 499.95),
('2025-02-10', 1030, 'East', 'Home', 4, 399.96),
('2025-02-10', 1031, 'West', 'Beauty', 6, 299.94),
('2025-02-10', 1032, 'North', 'Electronics', 8, 1199.92),
('2025-02-11', 1033, 'South', 'Fashion', 4, 399.96),
('2025-02-11', 1034, 'East', 'Home', 3, 269.97),
('2025-02-12', 1035, 'West', 'Beauty', 5, 249.95),
-- Back to normal
('2025-02-13', 1036, 'North', 'Electronics', 2, 259.98),
('2025-02-14', 1037, 'South', 'Fashion', 1, 89.99),
('2025-02-15', 1038, 'East', 'Home', 2, 179.98),
-- March baseline (normal)
('2025-03-01', 1039, 'West', 'Beauty', 1, 59.99),
('2025-03-01', 1040, 'North', 'Electronics', 2, 259.98),
('2025-03-02', 1041, 'South', 'Fashion', 3, 269.97),
('2025-03-02', 1042, 'East', 'Home', 1, 99.99),
('2025-03-03', 1043, 'West', 'Beauty', 2, 119.98),
('2025-03-03', 1044, 'North', 'Electronics', 1, 199.99),
('2025-03-04', 1045, 'South', 'Fashion', 2, 179.98),
('2025-03-04', 1046, 'East', 'Home', 3, 299.97),
('2025-03-05', 1047, 'West', 'Beauty', 1, 79.99),
('2025-03-05', 1048, 'North', 'Electronics', 2, 299.98),
('2025-03-06', 1049, 'South', 'Fashion', 1, 99.99),
('2025-03-06', 1050, 'East', 'Home', 2, 189.98);

-- Verify data inserted
SELECT COUNT(*) as total_orders FROM orders;
SELECT order_date, SUM(revenue) as daily_revenue FROM orders GROUP BY order_date ORDER BY order_date;
