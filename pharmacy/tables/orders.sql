CREATE TABLE IF NOT EXISTS pharmacy.orders
(
    order_id      BIGINT      NOT NULL
        CONSTRAINT pk_orders PRIMARY KEY,
    clint_id      BIGINT      NOT NULL,
    order_goods   JSONB       NOT NULL,
    dt            TIMESTAMPTZ NOT NULL,
    status_id     SMALLINT    NOT NULL,
    ch_dt         TIMESTAMPTZ NOT NULL,
    ch_employeeid BIGINT      NOT NULL
)