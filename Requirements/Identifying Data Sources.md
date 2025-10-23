# 1.Magento Database

This database is the primary system for recording online sales transactions and customer interactions. It stores highly structured, relational data optimized for high-volume e-commerce operations with strict transactional guarantees. Typical transactions include customer registrations, product catalog management, order processing, payment processing, and inventory tracking. It acts as the single source of truth for all online sales records and customer data.

- Primary entities: Orders, Order_Items, Customers, Products, Categories, Subcategories, Payments.

- Workload profile: short, frequent transactions; high concurrency; ACID compliance; normalized schema optimized for e-commerce operations.

- Use cases: online order capture, payment processing, customer account management, product catalog management, order fulfillment tracking, customer analytics.

## Schema :
```mermaid
erDiagram
    CUSTOMERS {
        int customer_id PK
        varchar email UK
        varchar first_name
        varchar last_name
        varchar phone
        varchar city
        varchar state
        varchar country
        timestamp created_at
        boolean is_active
    }
    
    CATEGORIES {
        int category_id PK
        varchar category_name
        int parent_category_id FK
        boolean is_active
        timestamp created_at
    }
    
    SUBCATEGORIES {
        int subcategory_id PK
        int category_id FK
        varchar subcategory_name
        boolean is_active
        timestamp created_at
    }
    
    PRODUCTS {
        int product_id PK
        varchar sku UK
        varchar name
        int category_id FK
        int subcategory_id FK
        decimal price
        decimal cost
        varchar brand
        boolean is_active
        timestamp created_at
    }
    
    ORDERS {
        int order_id PK
        varchar order_number UK
        int customer_id FK
        timestamp order_date
        enum status
        decimal total_amount
        decimal tax_amount
        decimal shipping_amount
        decimal discount_amount
        varchar payment_method
        varchar shipping_method
    }
    
    ORDER_ITEMS {
        int item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
        decimal total_price
    }
    
    PAYMENTS {
        int payment_id PK
        int order_id FK
        varchar payment_method
        decimal amount
        enum payment_status
        varchar transaction_id
        timestamp payment_date
    }
    
    CUSTOMERS ||--o{ ORDERS : "places"
    CATEGORIES ||--o{ SUBCATEGORIES : "contains"
    SUBCATEGORIES ||--o{ PRODUCTS : "subcategorizes"
    ORDERS ||--o{ ORDER_ITEMS : "contains"
    ORDERS ||--o{ PAYMENTS : "has"
    PRODUCTS ||--o{ ORDER_ITEMS : "included_in"
```
# 2.Odoo ERB Database

This database is the primary system for recording enterprise resource planning (ERP) operations and inventory management. It stores highly structured, relational data optimized for business process management with strict transactional guarantees. Typical transactions include product catalog management, supplier relationship management, inventory tracking, B2B sales order processing, and warehouse operations. It acts as the single source of truth for all business operations, inventory levels, and supplier relationships.

- Primary entities: Products, Suppliers, Warehouse, Inventory_Stock, Sales_Orders, Sales_Order_Items.

- Workload profile: medium to long-running transactions; moderate concurrency; ACID compliance; normalized schema optimized for business operations and inventory management.

- Use cases: product catalog management, supplier relationship management, inventory tracking, B2B sales order processing, warehouse operations, business analytics, cost management.

## Schema :
```mermaid
erDiagram
    PRODUCTS {
        int product_id PK
        varchar product_name
        varchar product_code UK
        varchar category
        decimal list_price
        decimal standard_price
        enum product_type
        boolean is_active
        timestamp created_at
    }
    
    SUPPLIERS {
        int supplier_id PK
        varchar supplier_name
        varchar supplier_code UK
        varchar email
        varchar phone
        varchar city
        varchar country
        boolean is_active
        timestamp created_at
    }
    
    WAREHOUSE {
        int warehouse_id PK
        varchar warehouse_name
        varchar warehouse_code UK
        varchar location
        boolean is_active
        timestamp created_at
    }
    
    INVENTORY_STOCK {
        int stock_id PK
        int product_id FK
        int warehouse_id FK
        decimal quantity
        decimal reserved_quantity
        decimal available_quantity
        timestamp updated_at
    }
    
    SALES_ORDERS {
        int order_id PK
        varchar order_reference UK
        varchar customer_name
        varchar customer_email
        date order_date
        enum status
        decimal total_amount
        text notes
        timestamp created_at
    }
    
    SALES_ORDER_ITEMS {
        int item_id PK
        int order_id FK
        int product_id FK
        varchar product_name
        decimal quantity
        decimal unit_price
        decimal total_price
        text notes
    }
    
    SUPPLIERS ||--o{ PRODUCTS : "supplies"
    PRODUCTS ||--o{ INVENTORY_STOCK : "stocked_in"
    WAREHOUSE ||--o{ INVENTORY_STOCK : "contains"
    PRODUCTS ||--o{ SALES_ORDER_ITEMS : "sold_as"
    SALES_ORDERS ||--o{ SALES_ORDER_ITEMS : "contains"
```

# Freshdesk customer support Database :

This database is the primary system for recording customer support operations and service interactions. It stores highly structured, relational data optimized for customer service management with strict transactional guarantees. Typical transactions include ticket creation, agent assignment, customer communication tracking, resolution management, and satisfaction monitoring. It acts as the single source of truth for all customer support interactions and service quality metrics.

- Primary entities: Customers, Agents, Tickets.

- Workload profile: short to medium transactions; moderate concurrency; ACID compliance; normalized schema optimized for customer service operations and performance tracking.

- Use cases: ticket management, customer service tracking, agent performance monitoring, satisfaction measurement, support analytics, service quality management.

## Schema :
```mermaid
erDiagram
    CUSTOMERS {
        int customer_id PK
        varchar email UK
        varchar first_name
        varchar last_name
        varchar company
        varchar phone
        varchar city
        varchar country
        boolean is_active
        timestamp created_at
    }
    
    AGENTS {
        int agent_id PK
        varchar email UK
        varchar first_name
        varchar last_name
        varchar department
        boolean is_active
        timestamp created_at
    }
    
    TICKETS {
        int ticket_id PK
        varchar ticket_number UK
        int customer_id FK
        int agent_id FK
        varchar subject
        text description
        enum status
        enum priority
        enum type
        enum source
        varchar product_name
        timestamp created_at
        timestamp resolved_at
        timestamp closed_at
        timestamp first_response_at
        int response_time_minutes
        int resolution_time_minutes
        int satisfaction_rating
    }
    
    CUSTOMERS ||--o{ TICKETS : "creates"
    AGENTS ||--o{ TICKETS : "handles"
```

