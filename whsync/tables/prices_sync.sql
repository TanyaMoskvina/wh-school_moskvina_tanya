CREATE TABLE IF NOT EXISTS whsync.prices_sync
(
    log_id         BIGSERIAL      NOT NULL
        CONSTRAINT pk_prices_sync PRIMARY KEY,
    nm_id          BIGINT         NOT NULL,
    price          NUMERIC(10, 2) NOT NULL,
    ch_employee_id BIGINT         NOT NULL,
    ch_dt          TIMESTAMPTZ    NOT NULL,
    sync_dt        TIMESTAMPTZ    NULL
);