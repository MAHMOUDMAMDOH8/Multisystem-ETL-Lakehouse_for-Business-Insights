-- =====================================================
-- ODOO SAMPLE DATA (PostgreSQL)
-- =====================================================
-- Sample data for Odoo ERP database
-- This file inserts data into the public schema of odoo_db

-- Insert Products
INSERT INTO products (product_name, product_code, category, list_price, standard_price, product_type, is_active) VALUES
('Office Chair Pro', 'CHR-001', 'Furniture', 299.99, 199.99, 'Stockable', TRUE),
('Wireless Mouse', 'MSE-002', 'Electronics', 49.99, 29.99, 'Stockable', TRUE),
('Desk Lamp LED', 'LMP-003', 'Lighting', 89.99, 59.99, 'Stockable', TRUE),
('Monitor 24"', 'MON-004', 'Electronics', 249.99, 179.99, 'Stockable', TRUE),
('Keyboard Mechanical', 'KBD-005', 'Electronics', 129.99, 89.99, 'Stockable', TRUE),
('Consulting Service', 'SRV-001', 'Services', 150.00, 100.00, 'Service', TRUE),
('Software License', 'SW-001', 'Software', 199.99, 149.99, 'Consumable', TRUE);

-- Insert Suppliers
INSERT INTO suppliers (supplier_name, supplier_code, email, phone, city, country, is_active) VALUES
('Global Furniture Co', 'SUP-001', 'orders@globalfurniture.com', '+1-555-1001', 'Chicago', 'USA', TRUE),
('Tech Electronics Ltd', 'SUP-002', 'sales@techelectronics.com', '+1-555-1002', 'San Francisco', 'USA', TRUE),
('Lighting Solutions Inc', 'SUP-003', 'info@lightingsolutions.com', '+1-555-1003', 'Miami', 'USA', TRUE),
('Software Partners', 'SUP-004', 'partners@softwarepartners.com', '+1-555-1004', 'Seattle', 'USA', TRUE);

-- Insert Warehouse
INSERT INTO warehouse (warehouse_name, warehouse_code, location, is_active) VALUES
('Main Warehouse', 'WH-001', '123 Industrial Blvd, Chicago, IL', TRUE),
('East Coast Distribution', 'WH-002', '456 Commerce St, New York, NY', TRUE),
('West Coast Hub', 'WH-003', '789 Business Ave, Los Angeles, CA', TRUE);

-- Insert Inventory Stock
INSERT INTO inventory_stock (product_id, warehouse_id, quantity, reserved_quantity) VALUES
(1, 1, 50, 5),
(1, 2, 30, 2),
(2, 1, 200, 15),
(2, 3, 150, 10),
(3, 1, 75, 8),
(3, 2, 40, 3),
(4, 1, 25, 4),
(4, 3, 20, 2),
(5, 1, 100, 12),
(5, 2, 60, 7);

-- Insert Sales Orders
INSERT INTO sales_orders (order_reference, customer_name, customer_email, order_date, status, total_amount, notes) VALUES
('SO-001', 'ABC Corporation', 'orders@abccorp.com', '2024-01-15', 'Done', 899.97, 'Bulk office furniture order'),
('SO-002', 'Tech Startup Inc', 'procurement@techstartup.com', '2024-01-16', 'Sale', 429.97, 'IT equipment for new office'),
('SO-003', 'Global Services Ltd', 'admin@globalservices.com', '2024-01-17', 'Sent', 299.99, 'Single item order'),
('SO-004', 'Innovation Labs', 'orders@innovationlabs.com', '2024-01-18', 'Draft', 579.97, 'Mixed product order'),
('SO-005', 'Enterprise Solutions', 'procurement@enterprisesol.com', '2024-01-19', 'Done', 1199.95, 'Large equipment order');

-- Insert Sales Order Items
INSERT INTO sales_order_items (order_id, product_id, product_name, quantity, unit_price, total_price, notes) VALUES
(1, 1, 'Office Chair Pro', 3, 299.99, 899.97, 'Bulk discount applied'),
(2, 2, 'Wireless Mouse', 2, 49.99, 99.98, 'Standard pricing'),
(2, 4, 'Monitor 24"', 1, 249.99, 249.99, 'Monitor with stand'),
(2, 5, 'Keyboard Mechanical', 1, 129.99, 129.99, 'Blue switches'),
(3, 1, 'Office Chair Pro', 1, 299.99, 299.99, 'Single item'),
(4, 3, 'Desk Lamp LED', 2, 89.99, 179.98, 'LED lighting'),
(4, 5, 'Keyboard Mechanical', 2, 129.99, 259.98, 'Mechanical keyboards'),
(4, 2, 'Wireless Mouse', 1, 49.99, 49.99, 'Wireless mouse'),
(5, 1, 'Office Chair Pro', 2, 299.99, 599.98, 'Executive chairs'),
(5, 4, 'Monitor 24"', 2, 249.99, 499.98, 'Dual monitor setup'),
(5, 5, 'Keyboard Mechanical', 1, 129.99, 129.99, 'Gaming keyboard');
