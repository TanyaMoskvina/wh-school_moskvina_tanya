CREATE TABLE IF NOT EXISTS history.sales_changes
(
    log_id                  BIGSERIAL   NOT NULL
        CONSTRAINT pk_sales_changes PRIMARY KEY,
    sale_id                 BIGINT      NOT NULL,
    client_id               BIGINT      NULL,
    is_delivery             BOOLEAN     NOT NULL,
    delivery_info           JSONB       NULL,
    status                  CHAR(3)     NOT NULL,
    dt                      TIMESTAMPTZ NOT NULL,
    responsible_employee_id BIGINT      NOT NULL,
    ch_employee_id          BIGINT      NOT NULL,
    ch_dt                   TIMESTAMPTZ NOT NULL
);