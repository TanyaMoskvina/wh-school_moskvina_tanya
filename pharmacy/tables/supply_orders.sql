CREATE TABLE IF NOT EXISTS pharmacy.supply_orders
(
    supply_order_id         BIGINT      NOT NULL
        CONSTRAINT pk_supply_orders PRIMARY KEY,
    supplier_id             SMALLINT    NOT NULL,
    order_info              JSONB       NOT NULL,
    responsible_employee_id BIGINT      NOT NULL,
    dt                      TIMESTAMPTZ NOT NULL
)