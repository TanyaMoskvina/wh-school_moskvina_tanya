CREATE TABLE IF NOT EXISTS pharmacy.goods_on_place
(
    nm_id    BIGINT NOT NULL,
    place_id BIGINT NOT NULL,
    quantity INT    NOT NULL,
    CONSTRAINT pk_goods_on_place PRIMARY KEY (nm_id, place_id)
);