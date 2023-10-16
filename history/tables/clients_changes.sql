CREATE TABLE IF NOT EXISTS history.clients_changes
(
    log_id         BIGSERIAL   NOT NULL
        CONSTRAINT pk_clients_changes PRIMARY KEY,
    client_id      BIGINT      NOT NULL,
    phone          VARCHAR(11) NOT NULL,
    name           VARCHAR(64) NOT NULL,
    birth_date     DATE        NULL,
    ch_employee_id BIGINT      NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL
);