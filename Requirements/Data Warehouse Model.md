
## Unified Data Warehouse - Galaxy  Schema Design Summary

This database is the centralized analytical system that consolidates data from multiple source systems (Magento, Odoo, Freshdesk) into a unified star schema for comprehensive business intelligence and reporting. It stores denormalized, dimensional data optimized for analytical queries and business intelligence with focus on performance and flexibility. Typical operations include cross-system analytics, historical trend analysis, customer journey tracking, and operational performance monitoring. It acts as the single source of truth for all business analytics and reporting across the organization.

- Primary entities: dim_date, dim_customer, dim_product, dim_channel, dim_support_agent, dim_time, fact_sales, fact_inventory_snapshot, fact_support_tickets.

- Workload profile: complex analytical queries; read-heavy operations; optimized for aggregations and reporting; denormalized star schema design.

- Use cases: business intelligence, cross-system analytics, customer 360 analysis, inventory optimization, support performance monitoring, executive dashboards, trend analysis.

# Granularity : 

### 1. FACT_SALES

Grain: One row per order item per order per day

- Primary Grain: Individual order item within a specific order on a specific date


- Business Meaning: Each record represents a single product sold in a specific order at a specific point in time


### 2. FACT_INVENTORY_SNAPSHOT

Grain: One row per product per warehouse per day

- Primary Grain: Daily inventory snapshot for each product in each warehouse location

- Business Meaning: Each record represents the inventory status of a specific product in a specific warehouse at the end of a specific day


### 3. FACT_SUPPORT_TICKETS

Grain: One row per support ticket

- Primary Grain: Individual support ticket with creation and resolution dates

- Business Meaning: Each record represents a single support ticket with its lifecycle from creation to resolution


### Grain Summary :

|Fact Table|Grain Level|Business Process|Primary Use Case|
|---|---|---|---|
|FACT_SALES|Order Item + Date|E-commerce Sales|Revenue analysis, product performance|
|FACT_INVENTORY_SNAPSHOT|Product + Warehouse + Date|Inventory Management|Stock optimization, demand forecasting|
|FACT_SUPPORT_TICKETS|Ticket + Customer + Agent|Customer Support|Service quality, agent performance|



# Schema : 
```mermaid
erDiagram
    DIM_DATE {
        int date_key PK
        date date_value
        int day_of_week
        varchar day_name
        int month
        varchar month_name
        int quarter
        int year
        boolean is_weekend
        boolean is_holiday
    }
    
    DIM_CUSTOMER {
        int customer_key PK
        varchar customer_id
        varchar source_system
        varchar email
        varchar first_name
        varchar last_name
        varchar country
        varchar customer_segment
        date registration_date
        boolean is_active
    }
    
    DIM_PRODUCT {
        int product_key PK
        varchar product_id
        varchar units_in_stock
        varchar product_name
        varchar category
        varchar brand
        decimal current_price
        boolean is_active_magento
        boolean is_active_odoo
    }
    
    DIM_CHANNEL {
        int channel_key PK
        varchar channel_name
        varchar channel_type
        varchar description
        boolean is_active
    }
    
    DIM_SUPPORT_AGENT {
        int agent_key PK
        varchar agent_id
        varchar agent_name
        varchar department
        varchar tier
        boolean is_active
    }
    
    DIM_TIME {
        int time_key PK
        varchar time_value
        varchar hour
        varchar minute
        varchar am_pm
    }
    
    FACT_SALES {
        int sales_key PK
        int customer_key FK
        int product_key FK
        int order_date_key FK
        int time_key FK
        int channel_key FK
        varchar order_id
        varchar source_system
        int quantity
        decimal unit_price
        decimal usd_amount
        varchar order_status
        varchar payment_method
    }
    
    FACT_INVENTORY_SNAPSHOT {
        int inventory_key PK
        int product_key FK
        int snapshot_date_key FK
        varchar warehouse_location
        int opening_stock
        int closing_stock
        int quantity_sold
        int time_key FK
    }
    
    FACT_SUPPORT_TICKETS {
        int support_key PK
        int customer_key FK
        int agent_key FK
        int ticket_created_date_key FK
        int ticket_resolved_date_key FK
        int channel_key FK
        varchar ticket_id
        varchar source_system
        int first_response_minutes
        int time_key FK
        varchar priority
        varchar status
        varchar category
    }
    
    DIM_CUSTOMER ||--o{ FACT_SALES : "makes"
    DIM_PRODUCT ||--o{ FACT_SALES : "sold_in"
    DIM_DATE ||--o{ FACT_SALES : "ordered_on"
    DIM_TIME ||--o{ FACT_SALES : "ordered_at"
    DIM_CHANNEL ||--o{ FACT_SALES : "sold_through"
    
    DIM_PRODUCT ||--o{ FACT_INVENTORY_SNAPSHOT : "tracked_in"
    DIM_DATE ||--o{ FACT_INVENTORY_SNAPSHOT : "snapshot_on"
    DIM_TIME ||--o{ FACT_INVENTORY_SNAPSHOT : "snapshot_at"
    
    DIM_CUSTOMER ||--o{ FACT_SUPPORT_TICKETS : "creates"
    DIM_SUPPORT_AGENT ||--o{ FACT_SUPPORT_TICKETS : "handles"
    DIM_DATE ||--o{ FACT_SUPPORT_TICKETS : "created_on"
    DIM_DATE ||--o{ FACT_SUPPORT_TICKETS : "resolved_on"
    DIM_CHANNEL ||--o{ FACT_SUPPORT_TICKETS : "submitted_through"
    DIM_TIME ||--o{ FACT_SUPPORT_TICKETS : "created_at"
```


# Relationships:

- Cross-System Integration: Unified customer and product dimensions across all source systems

- Temporal Analysis: Comprehensive date and time dimensions for trend analysis

- Multi-Channel Support: Unified channel dimension for all customer touchpoints

# Business Logic:

- Unified Customer View: Single customer dimension consolidating data from Magento, Odoo, and Freshdesk

- Cross-System Analytics: Ability to analyze customer journey across sales, support, and business operations

- Inventory Optimization: Historical inventory tracking with sales correlation for demand forecasting

- Support Performance: Agent performance metrics with customer satisfaction correlation

- Revenue Analysis: Comprehensive sales analysis across all channels and time periods

- Operational Intelligence: Business process optimization through cross-system insights
