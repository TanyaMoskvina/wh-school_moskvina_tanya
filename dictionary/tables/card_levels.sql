CREATE TABLE IF NOT EXISTS dictionary.card_levels
(
    level_id     SMALLSERIAL   NOT NULL
        CONSTRAINT pk_card_levels PRIMARY KEY,
    discount     NUMERIC(4, 2) NOT NULL,
    amount_spent NUMERIC(8, 2) NOT NULL
)