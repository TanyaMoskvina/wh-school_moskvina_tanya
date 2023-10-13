CREATE TABLE IF NOT EXISTS history.clients_card_changes
(
    log_id         BIGSERIAL   NOT NULL
        CONSTRAINT pk_clients_card_changes PRIMARY KEY,
    card_id        BIGINT      NOT NULL,
    client_id      BIGINT      NOT NULL,
    level_id       SMALLINT    NOT NULL,
    ch_employee_id BIGINT      NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL
);