-- Каждый блок должен завершиться ОШИБКОЙ: БД не должна принимать такие данные.
-- (запускается по одному оператору, см. run_tests.sh)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (1, 3, -5, 2500);
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (1, 3, 0, 2500);
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (1, 3, 1, -10);
INSERT INTO orders (customer_id, ordered_at, status) VALUES (1, '2026-03-05 10:00', 'unknown');
INSERT INTO orders (customer_id, ordered_at) VALUES (1, NULL);
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (999, 3, 1, 2500);
