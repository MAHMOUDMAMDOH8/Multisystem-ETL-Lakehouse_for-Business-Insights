@echo off
REM =====================================================
REM DATABASE INITIALIZATION SCRIPT (Windows Batch)
REM =====================================================
REM This script initializes all source system databases
REM for the Multisystem ETL Lakehouse project

setlocal enabledelayedexpansion

REM Colors for output (Windows doesn't support colors in batch, so we'll use text)
set "INFO_PREFIX=[INFO]"
set "SUCCESS_PREFIX=[SUCCESS]"
set "WARNING_PREFIX=[WARNING]"
set "ERROR_PREFIX=[ERROR]"

REM Database connection parameters
set "DB_HOST=localhost"
set "DB_PORT=5432"
set "DB_USER=airflow"
set "DB_PASSWORD=airflow"

REM Database names for each source system
set "FRESHDESK_DB=freshdesk_db"
set "ODOO_DB=odoo_db"
set "MAGENTO_DB=magento_db"

echo.
echo =====================================================
echo   MULTISYSTEM ETL LAKEHOUSE - DATABASE INITIALIZER
echo =====================================================
echo.

REM Check if Docker is running
echo %INFO_PREFIX% Checking Docker...
docker ps >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Docker is not running or not accessible!
    echo %INFO_PREFIX% Please start Docker Desktop and try again.
    pause
    exit /b 1
)

REM Check if PostgreSQL container is running
echo %INFO_PREFIX% Checking PostgreSQL connection...
docker ps | findstr "postgres" >nul
if errorlevel 1 (
    echo %ERROR_PREFIX% PostgreSQL container is not running!
    echo %INFO_PREFIX% Please start the Docker Compose services first:
    echo %INFO_PREFIX%   docker compose up -d
    pause
    exit /b 1
)

REM Test PostgreSQL connection
docker exec multisystem-etl-lakehouse_for-business-insights-postgres-1 pg_isready -U %DB_USER% -d airflow >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Cannot connect to PostgreSQL database!
    pause
    exit /b 1
)

echo %SUCCESS_PREFIX% PostgreSQL is running and accessible

REM Create separate databases for each source system
echo %INFO_PREFIX% Creating source system databases...
for %%d in (%FRESHDESK_DB% %ODOO_DB% %MAGENTO_DB%) do (
    echo %INFO_PREFIX% Creating database: %%d
    docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d airflow -c "CREATE DATABASE %%d;" >nul 2>&1
    if errorlevel 1 (
        echo %WARNING_PREFIX% Database %%d might already exist, continuing...
    ) else (
        echo %SUCCESS_PREFIX% Database %%d created successfully
    )
)

REM Initialize Freshdesk
echo %INFO_PREFIX% Initializing Freshdesk Support Database (%FRESHDESK_DB%)...
echo %INFO_PREFIX% Executing: Freshdesk Schema Creation
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %FRESHDESK_DB% < "Source_systems\freshdesk\01_freshdesk_schema_pg.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Freshdesk Schema Creation
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Freshdesk Schema Creation completed successfully

echo %INFO_PREFIX% Executing: Freshdesk Sample Data
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %FRESHDESK_DB% < "Source_systems\freshdesk\02_freshdesk_sample_data_pg.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Freshdesk Sample Data
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Freshdesk Sample Data completed successfully

REM Configure CDC for Freshdesk
echo %INFO_PREFIX% Executing: Freshdesk CDC Setup
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %FRESHDESK_DB% < "Source_systems\freshdesk\03_freshdesk_cdc.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Freshdesk CDC setup
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Freshdesk CDC configured successfully

echo %SUCCESS_PREFIX% Freshdesk database (%FRESHDESK_DB%) initialized successfully

REM Initialize Odoo
echo %INFO_PREFIX% Initializing Odoo ERP Database (%ODOO_DB%)...
echo %INFO_PREFIX% Executing: Odoo Schema Creation
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %ODOO_DB% < "Source_systems\odoo\01_odoo_schema_pg.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Odoo Schema Creation
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Odoo Schema Creation completed successfully

echo %INFO_PREFIX% Executing: Odoo Sample Data
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %ODOO_DB% < "Source_systems\odoo\02_odoo_sample_data_pg.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Odoo Sample Data
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Odoo Sample Data completed successfully

REM Configure CDC for Odoo
echo %INFO_PREFIX% Executing: Odoo CDC Setup
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %ODOO_DB% < "Source_systems\odoo\03_odoo_cdc.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Odoo CDC setup
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Odoo CDC configured successfully

echo %SUCCESS_PREFIX% Odoo database (%ODOO_DB%) initialized successfully

REM Initialize Magento
echo %INFO_PREFIX% Initializing Magento E-commerce Database (%MAGENTO_DB%)...
echo %INFO_PREFIX% Executing: Magento Schema Creation
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %MAGENTO_DB% < "Source_systems\magento\01_magento_schema_pg.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Magento Schema Creation
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Magento Schema Creation completed successfully

echo %INFO_PREFIX% Executing: Magento Sample Data
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %MAGENTO_DB% < "Source_systems\magento\02_magento_sample_data_pg.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Magento Sample Data
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Magento Sample Data completed successfully

REM Configure CDC for Magento
echo %INFO_PREFIX% Executing: Magento CDC Setup
docker exec -i multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %MAGENTO_DB% < "Source_systems\magento\03_magento_cdc.sql" >nul 2>&1
if errorlevel 1 (
    echo %ERROR_PREFIX% Failed to execute Magento CDC setup
    pause
    exit /b 1
)
echo %SUCCESS_PREFIX% Magento CDC configured successfully

echo %SUCCESS_PREFIX% Magento database (%MAGENTO_DB%) initialized successfully

REM Verify databases
echo %INFO_PREFIX% Verifying database initialization...
for %%d in (%FRESHDESK_DB% %ODOO_DB% %MAGENTO_DB%) do (
    echo %INFO_PREFIX% Checking database: %%d
    for /f %%t in ('docker exec multisystem-etl-lakehouse_for-business-insights-postgres-1 psql -U %DB_USER% -d %%d -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = ''public'';" 2^>nul') do (
        set "table_count=%%t"
        set "table_count=!table_count: =!"
        if !table_count! gtr 0 (
            echo %SUCCESS_PREFIX% Database %%d has !table_count! tables
        ) else (
            echo %WARNING_PREFIX% Database %%d has no tables
        )
    )
)

REM Show summary
echo.
echo %INFO_PREFIX% Database Initialization Summary
echo ==================================
echo.
echo %SUCCESS_PREFIX% Database initialization completed successfully!
echo.
echo %INFO_PREFIX% You can now connect to the databases using:
echo   Host: localhost
echo   Port: 5432
echo   Username: airflow
echo   Password: airflow
echo.
echo %INFO_PREFIX% Separate databases created:
echo   - %FRESHDESK_DB% (Customer Support System)
echo   - %ODOO_DB% (ERP System)
echo   - %MAGENTO_DB% (E-commerce System)
echo.
echo %INFO_PREFIX% CDC configured per database (for Airbyte):
echo   Publication: airbyte_publication
echo   Replication Slot: airbyte_slot (pgoutput)
echo   Use these in each Airbyte Postgres source pointing to its database.
echo.
echo %INFO_PREFIX% Connection examples:
echo   Freshdesk: psql -h localhost -p 5432 -U airflow -d %FRESHDESK_DB%
echo   Odoo:      psql -h localhost -p 5432 -U airflow -d %ODOO_DB%
echo   Magento:   psql -h localhost -p 5432 -U airflow -d %MAGENTO_DB%
echo.

pause
