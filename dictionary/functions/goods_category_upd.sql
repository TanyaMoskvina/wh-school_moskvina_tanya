CREATE OR REPLACE FUNCTION dictionary.goods_category_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _category_id SMALLINT;
    _name        VARCHAR(256);
BEGIN

    SELECT COALESCE(gc.category_id, nextval('dictionary.goods_category_category_id_seq')) AS category_id,
           s.name
    INTO _category_id, _name
    FROM JSONB_TO_RECORD(_src) AS s (category_id SMALLINT,
                                     name        VARCHAR(256))
             LEFT JOIN dictionary.goods_category gc
                 ON gc.category_id = s.category_id;

    INSERT INTO dictionary.goods_category as gc (category_id,
                                                 name)
    SELECT _category_id,
           _name
    ON CONFLICT (category_id) DO UPDATE
        SET name = excluded.name;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;