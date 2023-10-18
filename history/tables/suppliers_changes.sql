CREATE TABLE IF NOT EXISTS history.suppliers_changes
(
    log_id         BIGSERIAL   NOT NULL
        CONSTRAINT pk_suppliers_changes PRIMARY KEY,
    supplier_id    BIGINT       NOT NULL,
    name           VARCHAR(128) NOT NULL,
    inn            VARCHAR(12)  NOT NULL,
    is_active      BOOLEAN      NOT NULL,
    ch_employee_id BIGINT       NOT NULL,
    ch_dt          TIMESTAMPTZ  NOT NULL
);