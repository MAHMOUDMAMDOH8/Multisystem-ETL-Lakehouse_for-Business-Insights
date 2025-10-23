-- =====================================================
-- ODOO SAMPLE DATA
-- =====================================================

USE odoo_erp;

-- Insert Products
INSERT INTO products (product_name, product_code, category, list_price, standard_price, product_type, is_active) VALUES
('iPhone 15 Pro 256GB', 'IPH15PRO-256', 'Electronics', 999.99, 750.00, 'Stockable', TRUE),
('Samsung Galaxy S24 Ultra', 'SAMS24U-512', 'Electronics', 1199.99, 900.00, 'Stockable', TRUE),
('MacBook Pro 16" M3 Max', 'MBP16-M3MAX', 'Electronics', 2499.99, 1800.00, 'Stockable', TRUE),
('Sony WH-1000XM5 Headphones', 'SONY-WH1000XM5', 'Electronics', 399.99, 250.00, 'Stockable', TRUE),
('Aluminum Sheet 1mm', 'AL-SHEET-1MM', 'Raw Materials', 15.00, 12.00, 'Stockable', TRUE),
('ABS Plastic Granules', 'ABS-GRANULES', 'Raw Materials', 8.50, 6.00, 'Stockable', TRUE),
('A17 Pro Chip', 'A17-PRO-CHIP', 'Components', 150.00, 100.00, 'Stockable', TRUE),
('Technical Support', 'TECH-SUPPORT', 'Services', 50.00, 30.00, 'Service', TRUE);

-- Insert Suppliers
INSERT INTO suppliers (supplier_name, supplier_code, email, phone, city, country, is_active) VALUES
('Raw Materials Supply Co', 'SUPP-001', 'sales@rawmaterials.com', '+1-555-2001', 'Houston', 'USA', TRUE),
('Component Manufacturers Ltd', 'SUPP-002', 'orders@componentmfg.com', '+1-555-2002', 'Phoenix', 'USA', TRUE),
('Logistics Partners Inc', 'SUPP-003', 'logistics@logpartners.com', '+1-555-2003', 'Atlanta', 'USA', TRUE),
('European Components GmbH', 'SUPP-004', 'sales@eurocomp.de', '+49-89-98765432', 'Munich', 'Germany', TRUE),
('Asian Manufacturing Co', 'SUPP-005', 'export@asianmfg.com', '+86-755-8765-4321', 'Shenzhen', 'China', TRUE);

-- Insert Warehouse
INSERT INTO warehouse (warehouse_name, warehouse_code, location, is_active) VALUES
('Main Warehouse', 'MAIN-WH', '100 Industrial Blvd, Detroit, MI', TRUE),
('Distribution Center', 'DIST-DC', '500 Commerce St, Atlanta, GA', TRUE),
('Manufacturing Floor', 'MFG-FLOOR', '200 Production Ave, Detroit, MI', TRUE),
('Returns Warehouse', 'RET-WH', '300 Service Rd, Chicago, IL', TRUE);

-- Insert Inventory Stock
INSERT INTO inventory_stock (product_id, warehouse_id, quantity, reserved_quantity) VALUES
-- Main Warehouse
(1, 1, 50, 5),
(2, 1, 30, 3),
(3, 1, 25, 2),
(4, 1, 100, 10),
(5, 1, 1000, 100),
(6, 1, 500, 50),
(7, 1, 150, 15),

-- Distribution Center
(1, 2, 20, 2),
(2, 2, 15, 1),
(3, 2, 10, 1),
(4, 2, 50, 5),

-- Manufacturing Floor
(5, 3, 500, 200),
(6, 3, 300, 150),
(7, 3, 75, 30),

-- Returns Warehouse
(1, 4, 5, 0),
(2, 4, 3, 0),
(3, 4, 2, 0),
(4, 4, 10, 0);

-- Insert Sales Orders
INSERT INTO sales_orders (order_reference, customer_name, customer_email, order_date, status, total_amount, notes) VALUES
('SO-2024-001', 'Global Electronics Corp', 'orders@globalelectronics.com', '2024-01-15', 'Done', 5399.95, 'Bulk order for retail chain'),
('SO-2024-002', 'Industrial Solutions Ltd', 'purchasing@industrialsolutions.com', '2024-01-16', 'Done', 3599.94, 'Industrial solutions order'),
('SO-2024-003', 'European Distributors AG', 'orders@eurodist.com', '2024-01-17', 'Sale', 11999.90, 'European distribution order'),
('SO-2024-004', 'Asia Pacific Trading Co', 'sales@asiatrading.com', '2024-01-18', 'Draft', 7999.92, 'Asia Pacific trading order'),
('SO-2024-005', 'Retail Chain Stores Inc', 'procurement@retailchain.com', '2024-01-19', 'Sent', 19999.80, 'Large retail chain order');

-- Insert Sales Order Items
INSERT INTO sales_order_items (order_id, product_id, product_name, quantity, unit_price, total_price, notes) VALUES
(1, 1, 'iPhone 15 Pro 256GB', 5, 999.99, 4999.95, 'Bulk order - 5 units'),
(2, 2, 'Samsung Galaxy S24 Ultra', 3, 1199.98, 3599.94, 'Industrial order - 3 units'),
(3, 3, 'MacBook Pro 16" M3 Max', 5, 2399.98, 11999.90, 'European order - 5 units'),
(4, 4, 'Sony WH-1000XM5 Headphones', 20, 399.996, 7999.92, 'Asia order - 20 units'),
(5, 1, 'iPhone 15 Pro 256GB', 20, 999.99, 19999.80, 'Large retail order - 20 units');
