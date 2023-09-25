CREATE TABLE IF NOT EXISTS shop.sales
(
    sales_id    integer     NOT NULL,
    dt          timestamptz NOT NULL,
    client_id   integer     NOT NULL,
    product_id  integer     NOT NULL,
    amount      integer     NOT NULL,
    employee_id integer     NOT NULL,
    CONSTRAINT pk_sales PRIMARY KEY (sales_id)
);