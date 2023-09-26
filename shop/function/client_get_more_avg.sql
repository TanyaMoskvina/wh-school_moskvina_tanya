CREATE OR REPLACE FUNCTION shop.client_get_more_avg() RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.name,
                     c.phone,
                     SUM(s.amount) AS sum_amount
              FROM shop.sales s
                       INNER JOIN shop.client c ON s.client_id = c.client_id
              GROUP BY c.client_id
              HAVING SUM(s.amount) > (SELECT AVG(q.sum)
                                      FROM (SELECT SUM(s.amount) AS sum
                                            FROM shop.sales s
                                            GROUP BY s.client_id) AS q)) res;
END
$$;