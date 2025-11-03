#!/bin/bash

# =====================================================
# DATABASE INITIALIZATION SCRIPT
# =====================================================
# This script initializes all source system databases
# for the Multisystem ETL Lakehouse project

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Database connection parameters
DB_HOST="localhost"
DB_PORT="5432"
DB_USER="airflow"
DB_PASSWORD="airflow"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if PostgreSQL is running
check_postgres() {
    print_status "Checking PostgreSQL connection..."
    
    # Check if PostgreSQL container is running
    if ! docker ps | grep -q "postgres"; then
        print_error "PostgreSQL container is not running!"
        print_status "Please start the Docker Compose services first:"
        print_status "  docker compose up -d"
        exit 1
    fi
    
    # Test connection
    if ! docker exec multisystem-etl-lakehouse_for-business-insights-postgres-1 pg_isready -U $DB_USER -d airflow > /dev/null 2>&1; then
        print_error "Cannot connect to PostgreSQL database!"
        exit 1
    fi
    
    print_success "PostgreSQL is running and accessible"
}

# Function to execute SQL file in PostgreSQL
execute_sql() {
    local sql_file=$1
    local description=$2
    
    print_status "Executing: $description"
    
    if [ ! -f "$sql_file" ]; then
        print_error "SQL file not found: $sql_file"
        return 1
    fi
    
    # Execute the PostgreSQL-compatible SQL file directly
    if docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U $DB_USER -d airflow < "$sql_file" > /dev/null 2>&1; then
        print_success "$description completed successfully"
    else
        print_error "Failed to execute: $description"
        return 1
    fi
}

# Function to create schema-specific databases
create_databases() {
    print_status "Creating source system databases..."
    
    # Create databases for each source system
    local databases=("freshdesk_support" "odoo_erp" "magento_ecommerce")
    
    for db in "${databases[@]}"; do
        print_status "Creating database: $db"
        
        # Create database (PostgreSQL doesn't have USE statement, so we'll use schema instead)
        docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U $DB_USER -d airflow << EOF
CREATE SCHEMA IF NOT EXISTS $db;
EOF
        
        if [ $? -eq 0 ]; then
            print_success "Schema $db created successfully"
        else
            print_error "Failed to create schema $db"
            return 1
        fi
    done
}

# Function to initialize Freshdesk database
init_freshdesk() {
    print_status "Initializing Freshdesk Support Database..."
    
    # Execute schema
    execute_sql "Source_systems/freshdesk/01_freshdesk_schema_pg.sql" "Freshdesk Schema Creation"
    
    # Execute sample data
    execute_sql "Source_systems/freshdesk/02_freshdesk_sample_data_pg.sql" "Freshdesk Sample Data"
    
    print_success "Freshdesk database initialized successfully"
}

# Function to initialize Odoo database
init_odoo() {
    print_status "Initializing Odoo ERP Database..."
    
    # Execute schema
    execute_sql "Source_systems/odoo/01_odoo_schema_pg.sql" "Odoo Schema Creation"
    
    # Execute sample data
    execute_sql "Source_systems/odoo/02_odoo_sample_data_pg.sql" "Odoo Sample Data"
    
    print_success "Odoo database initialized successfully"
}

# Function to initialize Magento database
init_magento() {
    print_status "Initializing Magento E-commerce Database..."
    
    # Execute schema
    execute_sql "Source_systems/magento/01_magento_schema_pg.sql" "Magento Schema Creation"
    
    # Execute sample data
    execute_sql "Source_systems/magento/02_magento_sample_data_pg.sql" "Magento Sample Data"
    
    print_success "Magento database initialized successfully"
}

# Function to verify database initialization
verify_databases() {
    print_status "Verifying database initialization..."
    
    # Check if tables exist in each schema
    local schemas=("freshdesk_support" "odoo_erp" "magento_ecommerce")
    
    for schema in "${schemas[@]}"; do
        print_status "Checking schema: $schema"
        
        local table_count=$(docker exec multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U $DB_USER -d airflow -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$schema';" 2>/dev/null | tr -d ' ')
        
        if [ "$table_count" -gt 0 ]; then
            print_success "Schema $schema has $table_count tables"
        else
            print_warning "Schema $schema has no tables"
        fi
    done
}

# Function to display database summary
show_summary() {
    print_status "Database Initialization Summary"
    echo "=================================="
    
    local schemas=("freshdesk_support" "odoo_erp" "magento_ecommerce")
    
    for schema in "${schemas[@]}"; do
        echo -e "\n${BLUE}Schema: $schema${NC}"
        echo "Tables:"
        
        docker exec multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U $DB_USER -d airflow -c "SELECT table_name FROM information_schema.tables WHERE table_schema = '$schema' ORDER BY table_name;" 2>/dev/null | grep -v "table_name" | grep -v "^-" | grep -v "rows)" | while read table; do
            if [ ! -z "$table" ]; then
                echo "  - $table"
            fi
        done
    done
    
    echo -e "\n${GREEN}Database initialization completed successfully!${NC}"
    echo -e "${BLUE}You can now connect to the databases using:${NC}"
    echo "  Host: localhost"
    echo "  Port: 5432"
    echo "  Database: airflow"
    echo "  Username: airflow"
    echo "  Password: airflow"
}

# Create Airbyte CDC publication and replication slot
setup_airbyte_cdc() {
    print_status "Configuring Airbyte CDC (publication and replication slot)..."

    # Create publication for all tables (covers all schemas within this DB)
    docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U $DB_USER -d airflow << 'EOF'
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication WHERE pubname = 'airbyte_publication'
    ) THEN
        EXECUTE 'CREATE PUBLICATION airbyte_publication FOR ALL TABLES';
    END IF;
END$$;
EOF

    # Create logical replication slot if it does not exist (pgoutput plugin)
    docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U $DB_USER -d airflow << 'EOF'
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_replication_slots WHERE slot_name = 'airbyte_slot'
    ) THEN
        PERFORM pg_create_logical_replication_slot('airbyte_slot', 'pgoutput');
    END IF;
END$$;
EOF

    if [ $? -eq 0 ]; then
        print_success "Airbyte CDC configured: publication 'airbyte_publication', slot 'airbyte_slot'"
    else
        print_error "Failed to configure Airbyte CDC"
        return 1
    fi
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "====================================================="
    echo "  MULTISYSTEM ETL LAKEHOUSE - DATABASE INITIALIZER"
    echo "====================================================="
    echo -e "${NC}"
    
    # Check prerequisites
    check_postgres
    
    # Create databases/schemas
    create_databases
    
    # Initialize each source system
    init_freshdesk
    init_odoo
    init_magento
    
    # Verify initialization
    verify_databases
    
    # Configure CDC for Airbyte
    setup_airbyte_cdc

    # Show summary
    show_summary
}

# Run main function
main "$@"
