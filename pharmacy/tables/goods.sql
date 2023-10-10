CREATE TABLE IF NOT EXISTS pharmacy.goods
(
    nm_id           BIGINT   NOT NULL
        CONSTRAINT pk_goods PRIMARY KEY,
    category_id     SMALLINT NOT NULL,
    release_form_id SMALLINT NOT NULL,
    manufacturer_id INT      NOT NULL,
    quantity        SMALLINT NOT NULL,
    place_id        INT      NOT NULL
)