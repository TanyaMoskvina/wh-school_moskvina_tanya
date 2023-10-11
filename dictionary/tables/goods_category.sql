CREATE TABLE IF NOT EXISTS dictionary.goods_category
(
    category_id SMALLSERIAL  NOT NULL
        CONSTRAINT pk_goods_category PRIMARY KEY,
    name        VARCHAR(256) NOT NULL
);