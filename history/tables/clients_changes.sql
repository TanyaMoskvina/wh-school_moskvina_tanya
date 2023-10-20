CREATE TABLE IF NOT EXISTS history.clients_changes
(
    log_id         BIGSERIAL   NOT NULL,
    client_id      BIGINT      NOT NULL,
    phone          VARCHAR(11) NOT NULL,
    name           VARCHAR(64) NOT NULL,
    birth_date     DATE        NULL,
    ch_employee_id BIGINT      NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL
) PARTITION BY RANGE (ch_dt);

CREATE INDEX IF NOT EXISTS ix_clients_changes_log_id ON history.clients_changes (log_id);
CREATE INDEX IF NOT EXISTS ix_clients_changes_ch_dt ON history.clients_changes (ch_dt);

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2023m10 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2023-10-01') TO ('2023-11-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2023m11 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2023-11-01') TO ('2023-12-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2023m12 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2023-12-01') TO ('2024-01-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m01 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m02 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m03 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m04 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m05 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-05-01') TO ('2024-06-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m06 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m07 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-07-01') TO ('2024-08-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m08 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-08-01') TO ('2024-09-01');

CREATE TABLE IF NOT EXISTS  history.clients_changes_y2024m09 PARTITION OF history.clients_changes
    FOR VALUES FROM ('2024-09-01') TO ('2024-10-01');