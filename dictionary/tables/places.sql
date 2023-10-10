CREATE TABLE IF NOT EXISTS dictionary.places
(
    place_id SERIAL  NOT NULL
        CONSTRAINT pk_places PRIMARY KEY,
    cabinet  CHAR(1) NOT NULL,
    section  CHAR(3) NOT NULL
)