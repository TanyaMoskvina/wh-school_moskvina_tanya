CREATE TABLE IF NOT EXISTS pharmacy.supplies
(
    supply_id      BIGINT      NOT NULL,
    nm_id          BIGINT      NOT NULL,
    quantity       SMALLINT    NOT NULL,
    supplier_id    BIGINT      NOT NULL,
    dt             TIMESTAMPTZ NOT NULL,
    is_accepted    BOOLEAN     NOT NULL,
    ch_employee_id BIGINT      NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL,
    CONSTRAINT pk_supplies PRIMARY KEY (supply_id, nm_id)
);