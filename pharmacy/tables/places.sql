CREATE TABLE IF NOT EXISTS pharmacy.places
(
    place_id        BIGINT NOT NULL
        CONSTRAINT pk_places PRIMARY KEY,
    parent_place_id BIGINT NULL,
    place_type_id   INT    NOT NULL
);