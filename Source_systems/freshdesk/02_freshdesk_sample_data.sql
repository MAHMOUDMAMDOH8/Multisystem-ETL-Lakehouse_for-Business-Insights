-- =====================================================
-- FRESHDESK SAMPLE DATA
-- =====================================================

USE freshdesk_support;

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
('bob.support@techcorp.com', 'Bob', 'Smith', 'Technical Support', TRUE),
('carol.support@techcorp.com', 'Carol', 'Williams', 'Billing Support', TRUE),
('david.support@techcorp.com', 'David', 'Brown', 'Sales Support', TRUE),
('eve.support@techcorp.com', 'Eve', 'Davis', 'Technical Support', TRUE),
('frank.support@techcorp.com', 'Frank', 'Miller', 'Billing Support', TRUE);

-- Insert Tickets
INSERT INTO tickets (
    ticket_number, customer_id, agent_id, subject, description, status, priority, type, source,
    product_name, created_at, resolved_at, closed_at, first_response_at,
    response_time_minutes, resolution_time_minutes, satisfaction_rating
) VALUES
('TKT-2024-001', 1, 1, 'iPhone 15 Pro not charging properly', 'The phone charges very slowly and sometimes stops charging completely. Tried different cables and chargers.', 'Resolved', 'High', 'Incident', 'Email',
 'iPhone 15 Pro', '2024-01-20 10:30:00', '2024-01-21 14:20:00', '2024-01-21 14:20:00', '2024-01-20 11:15:00',
 45, 2340, 5),

('TKT-2024-002', 2, 2, 'Samsung Galaxy S24 Ultra screen flickering', 'The display flickers randomly, especially when using certain apps. Very distracting.', 'Resolved', 'High', 'Incident', 'Phone',
 'Samsung Galaxy S24 Ultra', '2024-01-21 14:15:00', '2024-01-22 09:30:00', '2024-01-22 09:30:00', '2024-01-21 15:00:00',
 45, 1395, 4),

('TKT-2024-003', 3, 1, 'MacBook Pro M3 Max overheating', 'The laptop gets very hot during normal use and the fan runs constantly.', 'Open', 'Medium', 'Problem', 'Web',
 'MacBook Pro 16" M3 Max', '2024-01-22 09:45:00', NULL, NULL, '2024-01-22 10:30:00',
 45, NULL, NULL),

('TKT-2024-004', 4, 5, 'Sony headphones not connecting to phone', 'Cannot pair the WH-1000XM5 with my iPhone. Bluetooth keeps disconnecting.', 'Resolved', 'Medium', 'Incident', 'Chat',
 'Sony WH-1000XM5', '2024-01-23 11:20:00', '2024-01-23 16:45:00', '2024-01-23 16:45:00', '2024-01-23 12:00:00',
 40, 325, 5),

('TKT-2024-005', 5, 3, 'Billing question about invoice', 'Need clarification on charges in the latest invoice. Some items seem incorrect.', 'Resolved', 'Low', 'Question', 'Email',
 'Billing', '2024-01-24 08:30:00', '2024-01-24 14:15:00', '2024-01-24 14:15:00', '2024-01-24 09:00:00',
 30, 345, 4),

('TKT-2024-006', 6, 4, 'Product information request', 'Interested in bulk pricing for iPhone 15 Pro. Need details for 100+ units.', 'Open', 'Medium', 'Question', 'Web',
 'iPhone 15 Pro', '2024-01-24 16:20:00', NULL, NULL, '2024-01-24 17:00:00',
 40, NULL, NULL),

('TKT-2024-007', 7, 2, 'Samsung Galaxy warranty claim', 'Phone screen cracked after 2 months. Need to process warranty claim.', 'Pending', 'High', 'Incident', 'Email',
 'Samsung Galaxy S24 Ultra', '2024-01-25 13:45:00', NULL, NULL, '2024-01-25 14:30:00',
 45, NULL, NULL),

('TKT-2024-008', 8, 1, 'MacBook Pro return request', 'Want to return the MacBook Pro within 30-day return window.', 'Resolved', 'Medium', 'Task', 'Phone',
 'MacBook Pro 16" M3 Max', '2024-01-25 15:10:00', '2024-01-26 10:20:00', '2024-01-26 10:20:00', '2024-01-25 15:45:00',
 35, 915, 3),

('TKT-2024-009', 1, 5, 'Sony headphones sound quality issue', 'Audio quality is poor, especially with bass. Expected better from premium headphones.', 'Open', 'Medium', 'Problem', 'Email',
 'Sony WH-1000XM5', '2024-01-26 10:30:00', NULL, NULL, '2024-01-26 11:15:00',
 45, NULL, NULL),

('TKT-2024-010', 2, 6, 'Account access problem', 'Cannot log into my account. Password reset emails not received.', 'Resolved', 'High', 'Incident', 'Web',
 'Account Access', '2024-01-26 14:20:00', '2024-01-26 18:30:00', '2024-01-26 18:30:00', '2024-01-26 15:00:00',
 40, 250, 4);
