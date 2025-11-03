-- =====================================================
-- MAGENTO SAMPLE DATA (PostgreSQL)
-- =====================================================

SET search_path TO magento_ecommerce;

-- Insert Categories
INSERT INTO categories (category_name, parent_category_id, is_active) VALUES
('Electronics', NULL, TRUE),
('Clothing', NULL, TRUE),
('Home & Garden', NULL, TRUE),
('Books', NULL, TRUE);

-- Insert Subcategories
INSERT INTO subcategories (category_id, subcategory_name, is_active) VALUES
(1, 'Smartphones', TRUE),
(1, 'Laptops', TRUE),
(1, 'Tablets', TRUE),
(2, 'Men''s Clothing', TRUE),
(2, 'Women''s Clothing', TRUE),
(2, 'Kids'' Clothing', TRUE),
(3, 'Furniture', TRUE),
(3, 'Kitchen', TRUE),
(4, 'Fiction', TRUE),
(4, 'Non-Fiction', TRUE);

-- Insert Customers
INSERT INTO customers (email, first_name, last_name, phone, city, state, country, is_active) VALUES
('john.doe@email.com', 'John', 'Doe', '+1-555-2001', 'New York', 'NY', 'USA', TRUE),
('jane.smith@email.com', 'Jane', 'Smith', '+1-555-2002', 'Los Angeles', 'CA', 'USA', TRUE),
('mike.johnson@email.com', 'Mike', 'Johnson', '+1-555-2003', 'Chicago', 'IL', 'USA', TRUE),
('sarah.williams@email.com', 'Sarah', 'Williams', '+1-555-2004', 'Houston', 'TX', 'USA', TRUE),
('david.brown@email.com', 'David', 'Brown', '+1-555-2005', 'Phoenix', 'AZ', 'USA', TRUE),
('lisa.davis@email.com', 'Lisa', 'Davis', '+1-555-2006', 'Philadelphia', 'PA', 'USA', TRUE);

-- Insert Products
INSERT INTO products (sku, name, category_id, subcategory_id, price, cost, brand, is_active) VALUES
('PHONE-001', 'iPhone 15 Pro', 1, 1, 999.99, 799.99, 'Apple', TRUE),
('PHONE-002', 'Samsung Galaxy S24', 1, 1, 899.99, 699.99, 'Samsung', TRUE),
('LAPTOP-001', 'MacBook Pro 16"', 1, 2, 2499.99, 1999.99, 'Apple', TRUE),
('LAPTOP-002', 'Dell XPS 15', 1, 2, 1799.99, 1399.99, 'Dell', TRUE),
('TABLET-001', 'iPad Air', 1, 3, 599.99, 449.99, 'Apple', TRUE),
('SHIRT-001', 'Cotton T-Shirt', 2, 4, 29.99, 15.99, 'Generic', TRUE),
('JEANS-001', 'Denim Jeans', 2, 4, 79.99, 39.99, 'Generic', TRUE),
('CHAIR-001', 'Office Chair', 3, 7, 199.99, 119.99, 'Generic', TRUE),
('BOOK-001', 'Programming Guide', 4, 9, 49.99, 24.99, 'Tech Books', TRUE);

-- Insert Orders
INSERT INTO orders (order_number, customer_id, order_date, status, total_amount, tax_amount, shipping_amount, discount_amount, payment_method, shipping_method) VALUES
('ORD-001', 1, '2024-01-15 10:30:00', 'delivered', 1029.98, 82.40, 15.99, 0.00, 'Credit Card', 'Standard Shipping'),
('ORD-002', 2, '2024-01-16 14:20:00', 'shipped', 2499.99, 199.99, 25.99, 100.00, 'PayPal', 'Express Shipping'),
('ORD-003', 3, '2024-01-17 09:15:00', 'processing', 109.98, 8.80, 9.99, 0.00, 'Credit Card', 'Standard Shipping'),
('ORD-004', 4, '2024-01-18 16:45:00', 'pending', 1799.99, 143.99, 20.99, 50.00, 'Bank Transfer', 'Standard Shipping'),
('ORD-005', 5, '2024-01-19 11:30:00', 'delivered', 599.99, 48.00, 12.99, 0.00, 'Credit Card', 'Standard Shipping');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 999.99, 999.99),
(1, 6, 1, 29.99, 29.99),
(2, 3, 1, 2499.99, 2499.99),
(3, 6, 2, 29.99, 59.98),
(3, 7, 1, 79.99, 79.99),
(4, 4, 1, 1799.99, 1799.99),
(5, 5, 1, 599.99, 599.99);

-- Insert Payments
INSERT INTO payments (order_id, payment_method, amount, payment_status, transaction_id, payment_date) VALUES
(1, 'Credit Card', 1029.98, 'completed', 'TXN-001-2024', '2024-01-15 10:35:00'),
(2, 'PayPal', 2499.99, 'completed', 'TXN-002-2024', '2024-01-16 14:25:00'),
(3, 'Credit Card', 109.98, 'completed', 'TXN-003-2024', '2024-01-17 09:20:00'),
(4, 'Bank Transfer', 1799.99, 'pending', 'TXN-004-2024', '2024-01-18 16:50:00'),
(5, 'Credit Card', 599.99, 'completed', 'TXN-005-2024', '2024-01-19 11:35:00');
