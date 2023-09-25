CREATE OR REPLACE FUNCTION shop.sales_by_day(_day timestamp) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.name        AS product,
                     SUM(s.amount) AS amount_total,
                     c.name
              FROM shop.sales s
                       INNER JOIN shop.client c ON s.client_id = c.client_id
                       INNER JOIN shop.product p ON s.product_id = p.product_id
              WHERE s.dt::date = _day
              GROUP BY c.name, p.name) res;
END
$$;