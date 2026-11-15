-- Схема БД онлайн-магазина (PostgreSQL)
-- Сущности: группа товаров, товар, история цен, клиент, заказ, позиция заказа

CREATE TABLE product_groups (
    group_id   SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(200) NOT NULL,
    -- NULL = товар вне товарных групп (по условию так бывает)
    group_id   INTEGER REFERENCES product_groups (group_id) ON DELETE SET NULL
);

-- История цен: цена действует с valid_from до следующей записи
CREATE TABLE product_prices (
    product_id INTEGER       NOT NULL REFERENCES products (product_id),
    valid_from DATE          NOT NULL,
    price      NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    PRIMARY KEY (product_id, valid_from)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    email       VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INTEGER   NOT NULL REFERENCES customers (customer_id),
    ordered_at  TIMESTAMP NOT NULL,
    -- отменённые заказы не считаются продажами
    status      VARCHAR(20) NOT NULL DEFAULT 'new'
                CHECK (status IN ('new','paid','shipped','cancelled'))
);

-- unit_price - цена на момент продажи: после смены цены старые продажи не меняются
CREATE TABLE order_items (
    order_id   INTEGER       NOT NULL REFERENCES orders (order_id),
    product_id INTEGER       NOT NULL REFERENCES products (product_id),
    quantity   INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id)
);
