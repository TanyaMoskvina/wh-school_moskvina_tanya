CREATE TABLE IF NOT EXISTS dictionary.suppliers
(
    supplier_id    BIGINT       NOT NULL
        CONSTRAINT pk_suppliers PRIMARY KEY,
    name           VARCHAR(128) NOT NULL,
    inn            VARCHAR(12)  NOT NULL,
    is_active      BOOLEAN      NOT NULL,
    ch_employee_id BIGINT       NOT NULL,
    ch_dt          TIMESTAMPTZ  NOT NULL,
    CONSTRAINT uq_suppliers_inn UNIQUE (inn)
);