CREATE OR REPLACE FUNCTION shop.sales_get_by_clientid(_client_id integer) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT s.client_id,
                     p.product_id,
                     p.name,
                     SUM(s.amount * p.price) AS "Стоимость"
              FROM shop.sales s
                       INNER JOIN shop.product p ON s.product_id = p.product_id
              WHERE s.client_id = _client_id
              GROUP BY s.client_id, p.name, p.product_id) res;
END
$$;