CREATE TABLE IF NOT EXISTS pharmacy.sales_cancelled
(
    sale_id   BIGINT       NOT NULL
        CONSTRAINT pk_sales_cancelled PRIMARY KEY,
    client_id BIGINT       NOT NULL,
    nm_id     BIGINT       NOT NULL,
    quantity  INT          NOT NULL,
    reason    VARCHAR(128) NOT NULL,
    dt        TIMESTAMPTZ  NOT NULL
);