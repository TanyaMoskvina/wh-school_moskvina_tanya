CREATE TABLE IF NOT EXISTS dictionary.suppliers
(
    supplier SMALLSERIAL  NOT NULL
        CONSTRAINT pk_suppliers PRIMARY KEY,
    name     VARCHAR(128) NOT NULL
)