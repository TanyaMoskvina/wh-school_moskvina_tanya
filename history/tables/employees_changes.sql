CREATE TABLE IF NOT EXISTS history.employees_changes
(
    log_id         BIGSERIAL   NOT NULL
        CONSTRAINT pk_employees_changes PRIMARY KEY,
    employee_id    BIGINT      NOT NULL,
    phone          VARCHAR(11) NOT NULL,
    name           VARCHAR(64) NOT NULL,
    birth_date     DATE        NOT NULL,
    rank_id        SMALLINT    NOT NULL,
    ch_employee_id BIGINT      NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL
);