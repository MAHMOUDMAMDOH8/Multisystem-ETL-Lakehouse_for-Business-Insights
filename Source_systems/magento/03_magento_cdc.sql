-- الاتصال بقاعدة البيانات
\c magento_db;


SELECT pg_drop_replication_slot('mogento_slot') 
WHERE EXISTS (SELECT 1 FROM pg_replication_slots WHERE slot_name = 'mogento_slot');

DROP PUBLICATION IF EXISTS mogento_publication;


SELECT pg_create_logical_replication_slot('mogento_slot', 'pgoutput');


ALTER TABLE magento_ecommerce.categories REPLICA IDENTITY FULL;
ALTER TABLE magento_ecommerce.subcategories REPLICA IDENTITY FULL;
ALTER TABLE magento_ecommerce.customers REPLICA IDENTITY FULL;
ALTER TABLE magento_ecommerce.products REPLICA IDENTITY FULL;
ALTER TABLE magento_ecommerce.orders REPLICA IDENTITY FULL;
ALTER TABLE magento_ecommerce.order_items REPLICA IDENTITY FULL;
ALTER TABLE magento_ecommerce.payments REPLICA IDENTITY FULL;


CREATE PUBLICATION mogento_publication FOR TABLE
  magento_ecommerce.categories,
  magento_ecommerce.subcategories,
  magento_ecommerce.customers,
  magento_ecommerce.products,
  magento_ecommerce.orders,
  magento_ecommerce.order_items,
  magento_ecommerce.payments;
