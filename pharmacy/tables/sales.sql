CREATE TABLE IF NOT EXISTS pharmacy.sales
(
    sale_id                BIGINT      NOT NULL
        CONSTRAINT pk_sales PRIMARY KEY,
    client_id              BIGINT      NULL,
    sale_goods             JSONB       NOT NULL,
    dt                     TIMESTAMPTZ NOT NULL,
    reponsible_employee_id BIGINT      NOT NULL
)