-- =====================================================
-- MAGENTO SAMPLE DATA
-- =====================================================

USE magento_ecommerce;

-- Insert Categories
INSERT INTO categories (category_name, parent_category_id, is_active) VALUES
('Electronics', NULL, TRUE),
('Clothing', NULL, TRUE),
('Home & Garden', NULL, TRUE);

-- Insert Subcategories
INSERT INTO subcategories (category_id, subcategory_name, is_active) VALUES
(1, 'Smartphones', TRUE),
(1, 'Laptops', TRUE),
(1, 'Audio', TRUE),
(2, 'Men\'s Clothing', TRUE),
(2, 'Women\'s Clothing', TRUE),
(3, 'Furniture', TRUE),
(3, 'Kitchen', TRUE);

-- Insert Customers
INSERT INTO customers (email, first_name, last_name, phone, city, state, country, is_active) VALUES
('john.smith@email.com', 'John', 'Smith', '+1-555-0101', 'New York', 'NY', 'USA', TRUE),
('sarah.johnson@email.com', 'Sarah', 'Johnson', '+1-555-0102', 'Los Angeles', 'CA', 'USA', TRUE),
('michael.brown@email.com', 'Michael', 'Brown', '+1-555-0103', 'Chicago', 'IL', 'USA', TRUE),
('emily.davis@email.com', 'Emily', 'Davis', '+1-555-0104', 'Houston', 'TX', 'USA', TRUE),
('david.wilson@email.com', 'David', 'Wilson', '+1-555-0105', 'Phoenix', 'AZ', 'USA', TRUE);

-- Insert Products
INSERT INTO products (sku, name, category_id, subcategory_id, price, cost, brand, is_active) VALUES
('IPHONE-15-PRO', 'iPhone 15 Pro 256GB', 1, 1, 999.99, 750.00, 'Apple', TRUE),
('SAMSUNG-S24', 'Samsung Galaxy S24 Ultra', 1, 1, 1199.99, 900.00, 'Samsung', TRUE),
('MACBOOK-PRO-16', 'MacBook Pro 16" M3 Max', 1, 2, 2499.99, 1800.00, 'Apple', TRUE),
('DELL-XPS-15', 'Dell XPS 15 4K OLED', 1, 2, 1899.99, 1400.00, 'Dell', TRUE),
('SONY-HEADPHONES', 'Sony WH-1000XM5', 1, 3, 399.99, 250.00, 'Sony', TRUE),
('MENS-TSHIRT', 'Classic Cotton T-Shirt', 2, 4, 19.99, 8.00, 'BasicWear', TRUE),
('WOMENS-DRESS', 'Summer Floral Dress', 2, 5, 49.99, 20.00, 'FashionStyle', TRUE),
('DINING-TABLE', 'Modern Oak Dining Table', 3, 6, 899.99, 500.00, 'HomeFurnish', TRUE);

-- Insert Orders
INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, tax_amount, shipping_amount, discount_amount, payment_method, shipping_method) VALUES
('ORD-2024-001', 1, '2024-01-20 14:30:00', 'delivered', 1094.99, 80.00, 15.00, 0.00, 'Credit Card', 'Standard Shipping'),
('ORD-2024-002', 2, '2024-01-21 10:15:00', 'shipped', 1265.99, 96.00, 20.00, 50.00, 'PayPal', 'Express Shipping'),
('ORD-2024-003', 3, '2024-01-22 16:45:00', 'processing', 2724.99, 200.00, 25.00, 0.00, 'Credit Card', 'Standard Shipping'),
('ORD-2024-004', 4, '2024-01-23 09:30:00', 'delivered', 421.99, 32.00, 10.00, 20.00, 'Bank Transfer', 'Standard Shipping'),
('ORD-2024-005', 5, '2024-01-24 13:20:00', 'pending', 1318.99, 104.00, 15.00, 100.00, 'Credit Card', 'Standard Shipping');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 999.99, 999.99),
(2, 2, 1, 1199.99, 1199.99),
(3, 3, 1, 2499.99, 2499.99),
(4, 5, 1, 399.99, 399.99),
(5, 4, 1, 1899.99, 1899.99);

-- Insert Payments
INSERT INTO payments (order_id, payment_method, amount, payment_status, transaction_id, payment_date) VALUES
(1, 'Credit Card', 1094.99, 'completed', 'TXN-001-CC', '2024-01-20 14:35:00'),
(2, 'PayPal', 1265.99, 'completed', 'TXN-002-PP', '2024-01-21 10:20:00'),
(3, 'Credit Card', 2724.99, 'completed', 'TXN-003-CC', '2024-01-22 16:50:00'),
(4, 'Bank Transfer', 421.99, 'completed', 'TXN-004-BT', '2024-01-23 09:35:00'),
(5, 'Credit Card', 1318.99, 'pending', 'TXN-005-CC', '2024-01-24 13:25:00');
