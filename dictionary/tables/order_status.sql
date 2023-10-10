CREATE TABLE IF NOT EXISTS dictionary.order_status
(
    status_id SMALLSERIAL NOT NULL
        CONSTRAINT pk_orderstatus PRIMARY KEY,
    name      VARCHAR(16) NOT NULL
)