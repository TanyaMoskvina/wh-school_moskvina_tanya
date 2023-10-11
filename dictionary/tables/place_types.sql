CREATE TABLE IF NOT EXISTS dictionary.place_types
(
    place_type_id SERIAL      NOT NULL
        CONSTRAINT pk_place_types PRIMARY KEY,
    name          VARCHAR(32) NOT NULL
)