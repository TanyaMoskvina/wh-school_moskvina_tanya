CREATE OR REPLACE FUNCTION shop.client_get_by_productid(_product_id integer) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.name,
                     c.phone
              FROM shop.sales s
                       INNER JOIN shop.client c ON s.client_id = c.client_id
              WHERE s.product_id = _product_id) res;
END
$$;