CREATE TABLE IF NOT EXISTS pharmacy.prices
(
    nm_id          BIGINT         NOT NULL
        CONSTRAINT pk_prices PRIMARY KEY,
    price          NUMERIC(10, 2) NOT NULL,
    ch_employee_id BIGINT         NOT NULL,
    ch_dt          TIMESTAMPTZ    NOT NULL
);