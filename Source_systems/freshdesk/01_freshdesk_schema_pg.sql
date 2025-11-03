-- =====================================================
-- FRESHDESK CUSTOMER SUPPORT DATABASE SCHEMA (PostgreSQL)
-- =====================================================
-- Realistic Freshdesk database structure
-- This file creates tables in the public schema of freshdesk_db

-- =====================================================
-- 1. CUSTOMERS TABLE
-- =====================================================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    company VARCHAR(200),
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. AGENTS TABLE
-- =====================================================
CREATE TABLE agents (
    agent_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. TICKETS TABLE
-- =====================================================
CREATE TYPE ticket_status AS ENUM ('Open', 'Pending', 'Resolved', 'Closed');
CREATE TYPE ticket_priority AS ENUM ('Low', 'Medium', 'High', 'Urgent');
CREATE TYPE ticket_type AS ENUM ('Question', 'Incident', 'Problem', 'Task', 'Feature Request');
CREATE TYPE ticket_source AS ENUM ('Email', 'Phone', 'Chat', 'Web', 'API', 'Facebook', 'Twitter', 'Other');

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INTEGER NOT NULL,
    agent_id INTEGER,
    subject VARCHAR(500) NOT NULL,
    description TEXT,
    status ticket_status DEFAULT 'Open',
    priority ticket_priority DEFAULT 'Medium',
    type ticket_type DEFAULT 'Question',
    source ticket_source DEFAULT 'Email',
    product_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    closed_at TIMESTAMP NULL,
    first_response_at TIMESTAMP NULL,
    response_time_minutes INTEGER,
    resolution_time_minutes INTEGER,
    satisfaction_rating INTEGER CHECK (satisfaction_rating >= 1 AND satisfaction_rating <= 5),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);
