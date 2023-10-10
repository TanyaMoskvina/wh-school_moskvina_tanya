CREATE TABLE IF NOT EXISTS humanresource.clients
(
    client_id     BIGINT      NOT NULL
        CONSTRAINT pk_clients PRIMARY KEY,
    phone         VARCHAR(11) NOT NULL,
    name          VARCHAR(64) NOT NULL,
    birth_date    DATE        NULL,
    ch_dt         TIMESTAMP   NOT NULL,
    ch_employeeid BIGINT      NOT NULL
)