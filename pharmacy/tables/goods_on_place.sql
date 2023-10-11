CREATE TABLE IF NOT EXISTS pharmacy.goods_on_place
(
    nm_id    BIGINT NOT NULL,
    quantity INT    NOT NULL,
    place_id INT    NOT NULL,
    CONSTRAINT pk_goods_on_place PRIMARY KEY (nm_id, place_id)
)