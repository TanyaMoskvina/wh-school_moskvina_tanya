CREATE TABLE IF NOT EXISTS dictionary.suppliers
(
    supplier_id SMALLSERIAL  NOT NULL
        CONSTRAINT pk_suppliers PRIMARY KEY,
    name        VARCHAR(128) NOT NULL
);