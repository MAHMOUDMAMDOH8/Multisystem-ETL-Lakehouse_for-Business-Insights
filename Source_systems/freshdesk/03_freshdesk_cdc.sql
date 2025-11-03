-- CDC configuration for Freshdesk (database: freshdesk_db)
-- Creates replication slot, sets replica identity, and creates publication

-- Step 4: Create replication slot (requires REPLICATION privilege)
SELECT pg_create_logical_replication_slot('airbyte_slot', 'pgoutput');

-- Step 5: Set replica identities (use PKs)
ALTER TABLE public.customers REPLICA IDENTITY DEFAULT;
ALTER TABLE public.agents REPLICA IDENTITY DEFAULT;
ALTER TABLE public.tickets REPLICA IDENTITY DEFAULT;

-- Step 5: Create publication for specific tables
DROP PUBLICATION IF EXISTS airbyte_publication;
CREATE PUBLICATION airbyte_publication FOR TABLE
  public.customers,
  public.agents,
  public.tickets;


