CREATE TABLE IF NOT EXISTS dictionary.ranks
(
    rank_id SMALLSERIAL    NOT NULL
        CONSTRAINT pk_ranks PRIMARY KEY,
    name    VARCHAR(32)    NOT NULL,
    salary  NUMERIC(10, 2) NOT NULL
)