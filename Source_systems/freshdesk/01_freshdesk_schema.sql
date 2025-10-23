-- =====================================================
-- FRESHDESK CUSTOMER SUPPORT DATABASE SCHEMA
-- =====================================================
-- Realistic Freshdesk database structure

CREATE DATABASE freshdesk_support;
USE freshdesk_support;

-- =====================================================
-- 1. CUSTOMERS TABLE
-- =====================================================
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
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
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
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
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    agent_id INT,
    subject VARCHAR(500) NOT NULL,
    description TEXT,
    status ENUM('Open', 'Pending', 'Resolved', 'Closed') DEFAULT 'Open',
    priority ENUM('Low', 'Medium', 'High', 'Urgent') DEFAULT 'Medium',
    type ENUM('Question', 'Incident', 'Problem', 'Task', 'Feature Request') DEFAULT 'Question',
    source ENUM('Email', 'Phone', 'Chat', 'Web', 'API', 'Facebook', 'Twitter', 'Other') DEFAULT 'Email',
    product_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    closed_at TIMESTAMP NULL,
    first_response_at TIMESTAMP NULL,
    response_time_minutes INT,
    resolution_time_minutes INT,
    satisfaction_rating INT CHECK (satisfaction_rating >= 1 AND satisfaction_rating <= 5),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);
