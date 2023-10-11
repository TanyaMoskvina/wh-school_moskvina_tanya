CREATE TABLE IF NOT EXISTS dictionary.goods
(
    nm_id           BIGINT       NOT NULL
        CONSTRAINT pk_goods PRIMARY KEY,
    name            VARCHAR(256) NOT NULL,
    by_prescription BOOLEAN      NOT NULL,
    dosage          VARCHAR(16)  NULL,
    count_in_pack   SMALLINT     NOT NULL,
    release_form_id SMALLINT     NOT NULL,
    category_id     SMALLINT     NOT NULL,
    manufacturer_id INT          NOT NULL
);