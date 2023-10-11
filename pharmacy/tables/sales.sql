CREATE TABLE IF NOT EXISTS pharmacy.sales
(
    sale_id                 BIGINT      NOT NULL
        CONSTRAINT pk_sales PRIMARY KEY,
    client_id               BIGINT      NULL,
    goods                   JSONB       NOT NULL,
    is_delivery             BOOLEAN     NOT NULL,
    delivery_info           JSONB       NULL,
    status                  CHAR(3)     NOT NULL,
    dt                      TIMESTAMPTZ NOT NULL,
    responsible_employee_id BIGINT      NOT NULL,
    ch_employee_id          BIGINT      NOT NULL,
    ch_dt                   TIMESTAMPTZ NOT NULL
);