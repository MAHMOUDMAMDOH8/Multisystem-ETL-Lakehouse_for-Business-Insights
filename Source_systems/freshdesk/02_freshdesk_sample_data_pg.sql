-- =====================================================
-- FRESHDESK SAMPLE DATA (PostgreSQL)
-- =====================================================
-- Sample data for Freshdesk database
-- This file inserts data into the public schema of freshdesk_db

-- Insert Customers
INSERT INTO customers (email, first_name, last_name, company, phone, city, country, is_active) VALUES
('john.smith@email.com', 'John', 'Smith', 'Global Electronics Corp', '+1-555-0101', 'New York', 'USA', TRUE),
('sarah.johnson@email.com', 'Sarah', 'Johnson', 'Industrial Solutions Ltd', '+1-555-0102', 'Los Angeles', 'USA', TRUE),
('michael.brown@email.com', 'Michael', 'Brown', 'European Distributors AG', '+1-555-0103', 'Chicago', 'USA', TRUE),
('emily.davis@email.com', 'Emily', 'Davis', 'Asia Pacific Trading Co', '+1-555-0104', 'Houston', 'USA', TRUE),
('david.wilson@email.com', 'David', 'Wilson', 'Retail Chain Stores Inc', '+1-555-0105', 'Phoenix', 'USA', TRUE),
('lisa.anderson@email.com', 'Lisa', 'Anderson', 'TechStart Inc', '+1-555-0106', 'Philadelphia', 'USA', TRUE),
('robert.taylor@email.com', 'Robert', 'Taylor', 'Innovation Labs', '+1-555-0107', 'San Antonio', 'USA', TRUE),
('jennifer.thomas@email.com', 'Jennifer', 'Thomas', 'Future Systems', '+1-555-0108', 'San Diego', 'USA', TRUE);

-- Insert Agents
INSERT INTO agents (email, first_name, last_name, department, is_active) VALUES
('alice.support@techcorp.com', 'Alice', 'Johnson', 'Technical Support', TRUE),
('bob.support@techcorp.com', 'Bob', 'Williams', 'Customer Service', TRUE),
('carol.support@techcorp.com', 'Carol', 'Jones', 'Technical Support', TRUE),
('dave.support@techcorp.com', 'Dave', 'Brown', 'Sales Support', TRUE),
('eve.support@techcorp.com', 'Eve', 'Davis', 'Technical Support', TRUE);

-- Insert Tickets
INSERT INTO tickets (ticket_number, customer_id, agent_id, subject, description, status, priority, type, source, product_name, created_at, resolved_at, response_time_minutes, resolution_time_minutes, satisfaction_rating) VALUES
('FD-001', 1, 1, 'Login Issues', 'Unable to access the customer portal', 'Resolved', 'High', 'Incident', 'Email', 'Customer Portal', '2024-01-15 09:30:00', '2024-01-15 11:45:00', 15, 135, 4),
('FD-002', 2, 2, 'Product Information Request', 'Need details about pricing for bulk orders', 'Open', 'Medium', 'Question', 'Web', 'Product Catalog', '2024-01-16 14:20:00', NULL, 5, NULL, NULL),
('FD-003', 3, 1, 'Technical Support', 'Software installation problems', 'Pending', 'High', 'Problem', 'Phone', 'Software Suite', '2024-01-17 10:15:00', NULL, 30, NULL, NULL),
('FD-004', 4, 3, 'Feature Request', 'Add export functionality to reports', 'Open', 'Low', 'Feature Request', 'Email', 'Reporting Tool', '2024-01-18 16:45:00', NULL, 20, NULL, NULL),
('FD-005', 5, 2, 'Account Setup', 'Need help setting up new account', 'Resolved', 'Medium', 'Task', 'Chat', 'Account Management', '2024-01-19 08:30:00', '2024-01-19 09:15:00', 10, 45, 5),
('FD-006', 6, 4, 'Billing Inquiry', 'Question about invoice charges', 'Open', 'Medium', 'Question', 'Email', 'Billing System', '2024-01-20 13:20:00', NULL, 25, NULL, NULL),
('FD-007', 7, 1, 'System Performance', 'Slow response times on dashboard', 'Resolved', 'High', 'Problem', 'Web', 'Dashboard', '2024-01-21 11:00:00', '2024-01-21 14:30:00', 20, 210, 3),
('FD-008', 8, 5, 'Training Request', 'Need training on new features', 'Open', 'Low', 'Task', 'Phone', 'Training Portal', '2024-01-22 15:30:00', NULL, 15, NULL, NULL);
