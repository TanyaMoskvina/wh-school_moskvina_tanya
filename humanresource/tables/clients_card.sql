CREATE TABLE IF NOT EXISTS humanresource.clients_card
(
    card_id        BIGINT         NOT NULL
        CONSTRAINT pk_clients_card PRIMARY KEY,
    client_id      BIGINT         NOT NULL,
    level_id       SMALLINT       NOT NULL,
    amount_spent   NUMERIC(10, 2) NOT NULL,
    ch_employee_id BIGINT         NOT NULL,
    ch_dt          TIMESTAMPTZ    NOT NULL
);