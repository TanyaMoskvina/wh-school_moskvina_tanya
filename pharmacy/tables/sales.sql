CREATE TABLE IF NOT EXISTS pharmacy.sales
(
    sale_id     BIGINT      NOT NULL
        CONSTRAINT pk_sales PRIMARY KEY,
    clint_id    BIGINT      NULL,
    sale_goods  JSONB       NOT NULL,
    dt          TIMESTAMPTZ NOT NULL,
    employee_id BIGINT      NOT NULL
)