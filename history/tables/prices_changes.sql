CREATE TABLE IF NOT EXISTS history.prices_changes
(
    log_id         BIGSERIAL      NOT NULL
        CONSTRAINT pk_prices_changes PRIMARY KEY,
    nm_id          BIGINT         NOT NULL,
    price          NUMERIC(10, 2) NOT NULL,
    ch_employee_id BIGINT         NOT NULL,
    ch_dt          TIMESTAMPTZ    NOT NULL
);