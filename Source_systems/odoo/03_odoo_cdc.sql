-- CDC configuration for Odoo (database: odoo_db)

-- Step 4: Create replication slot
SELECT pg_create_logical_replication_slot('odoo_slot', 'pgoutput');

-- Step 5: Set replica identities (schema: public)
ALTER TABLE public.products REPLICA IDENTITY DEFAULT;
ALTER TABLE public.suppliers REPLICA IDENTITY DEFAULT;
ALTER TABLE public.warehouse REPLICA IDENTITY DEFAULT;
ALTER TABLE public.inventory_stock REPLICA IDENTITY DEFAULT;
ALTER TABLE public.sales_orders REPLICA IDENTITY DEFAULT;
ALTER TABLE public.sales_order_items REPLICA IDENTITY DEFAULT;

-- Step 6: Create publication
DROP PUBLICATION IF EXISTS odoo_publication;
CREATE PUBLICATION odoo_publication FOR TABLE
  public.products,
  public.suppliers,
  public.warehouse,
  public.inventory_stock,
  public.sales_orders,
  public.sales_order_items;
