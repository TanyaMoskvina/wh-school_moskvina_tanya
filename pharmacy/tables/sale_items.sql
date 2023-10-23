CREATE TABLE IF NOT EXISTS pharmacy.sale_items
(
    sale_id     BIGINT         NOT NULL,
    nm_id       BIGINT         NOT NULL,
    quantity    SMALLINT       NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL,
    CONSTRAINT pk_sale_items PRIMARY KEY (sale_id, nm_id)
);