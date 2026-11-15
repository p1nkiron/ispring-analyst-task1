# Схема БД онлайн-магазина

```mermaid
erDiagram
    PRODUCT_GROUPS |o--o{ PRODUCTS : "содержит"
    PRODUCTS ||--o{ PRODUCT_PRICES : "имеет историю цен"
    CUSTOMERS ||--o{ ORDERS : "делает"
    ORDERS ||--|{ ORDER_ITEMS : "состоит из"
    PRODUCTS ||--o{ ORDER_ITEMS : "продаётся в"

    PRODUCT_GROUPS {
        int group_id PK
        string name
    }
    PRODUCTS {
        int product_id PK
        string name
        int group_id FK "может быть NULL"
    }
    PRODUCT_PRICES {
        int product_id PK
        date valid_from PK
        decimal price
    }
    CUSTOMERS {
        int customer_id PK
        string name
        string email
    }
    ORDERS {
        int order_id PK
        int customer_id FK
        timestamp ordered_at
    }
    ORDER_ITEMS {
        int order_id PK
        int product_id PK
        int quantity
        decimal unit_price
    }
```

## Ключевые решения

- **Не все товары состоят в группе:** `products.group_id` может быть `NULL`; в отчёте такие товары идут как «Без группы» (`LEFT JOIN` + `COALESCE`).
- **Цена меняется со временем:** история цен хранится в `product_prices`, а в `order_items.unit_price` фиксируется цена на момент продажи. Поэтому отчёт за прошлые месяцы не меняется после смены цены.
- **Одна позиция заказа = один товар в заказе:** составной ключ (`order_id`, `product_id`); количество в `quantity`.
