CREATE OR REPLACE FUNCTION pharmacy.goods_on_place_get(_nm_id BIGINT DEFAULT NULL) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT gp.nm_id, gp.place_id, gp.quantity
              FROM pharmacy.goods_on_place gp
              WHERE gp.nm_id = COALESCE(_nm_id, gp.nm_id)) res;
END
$$;

