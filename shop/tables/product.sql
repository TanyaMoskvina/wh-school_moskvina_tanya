CREATE TABLE IF NOT EXISTS shop.product
(
    product_id  integer        NOT NULL,
    name        varchar(30)    NOT NULL,
    price       numeric(10, 2) NOT NULL,
    dt          timestamptz    NOT NULL,
    employee_id integer        NOT NULL,
    CONSTRAINT pk_product PRIMARY KEY (product_id)
);