CREATE TABLE IF NOT EXISTS humanresource.clients_card
(
    card_id   BIGINT   NOT NULL
        CONSTRAINT pk_clients_card PRIMARY KEY,
    client_id BIGINT   NOT NULL,
    level_id  SMALLINT NOT NULL
)