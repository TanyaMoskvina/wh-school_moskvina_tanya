CREATE TABLE IF NOT EXISTS dictionary.manufacturers
(
    manufacturer_id SERIAL       NOT NULL
        CONSTRAINT pk_manufacturers PRIMARY KEY,
    name            VARCHAR(256) NOT NULL,
    country         VARCHAR(32)  NOT NULL
);