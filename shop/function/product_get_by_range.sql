CREATE OR REPLACE FUNCTION shop.product_get_by_range(_start integer,
                                                     _end integer) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.name,
                     p.price
              FROM shop.product p
              WHERE p.price BETWEEN _start AND _end) res;
END
$$;