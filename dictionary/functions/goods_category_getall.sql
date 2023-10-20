CREATE OR REPLACE FUNCTION dictionary.goods_category_getall() RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT gc.category_id,
                     gc.name
              FROM dictionary.goods_category gc) res;
END
$$;

