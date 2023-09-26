CREATE TABLE IF NOT EXISTS shop.client
(
    client_id   integer     NOT NULL,
    name        varchar(30) NOT NULL,
    phone       varchar(11) NOT NULL,
    dt          timestamptz NOT NULL,
    employee_id integer     NOT NULL,
    CONSTRAINT pk_client       PRIMARY KEY (client_id),
    CONSTRAINT uq_client_phone UNIQUE (phone)
);