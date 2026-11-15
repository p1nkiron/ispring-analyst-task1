-- Отчёт: суммы и количество продаж по месяцам, товарным группам и товарам
SELECT
    date_trunc('month', o.ordered_at)::date AS month,
    COALESCE(g.name, 'Без группы')          AS product_group,
    p.name                                  AS product,
    COUNT(DISTINCT o.order_id)              AS orders_count,
    SUM(oi.quantity)                        AS items_sold,
    SUM(oi.quantity * oi.unit_price)        AS revenue
FROM order_items oi
JOIN orders   o ON o.order_id   = oi.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_groups g ON g.group_id = p.group_id   -- LEFT: товары без группы не теряем
GROUP BY date_trunc('month', o.ordered_at), g.group_id, g.name, p.product_id, p.name
ORDER BY month, product_group, product;
