CREATE TABLE IF NOT EXISTS pharmacy.prices
(
    nm_id         BIGINT         NOT NULL,
    price         NUMERIC(10, 2) NOT NULL,
    ch_dt         TIMESTAMPTZ    NOT NULL,
    ch_employeeid BIGINT         NOT NULL,
    CONSTRAINT pk_prices PRIMARY KEY (nm_id, price)
)