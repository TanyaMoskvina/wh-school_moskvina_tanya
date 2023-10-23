CREATE OR REPLACE FUNCTION pharmacy.goods_on_place_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
BEGIN
    WITH cte AS (
        SELECT s.nm_id,
               s.place_id,
               s.quantity,
               s.is_taken
        FROM JSONB_TO_RECORD(_src) AS s (nm_id    BIGINT,
                                         place_id BIGINT,
                                         quantity SMALLINT,
                                         is_taken BOOLEAN)
    )

    INSERT INTO pharmacy.goods_on_place AS gp (nm_id,
                                               place_id,
                                               quantity)
    SELECT c.nm_id,
           c.place_id,
           (SELECT CASE
                       WHEN c.is_taken THEN -c.quantity
                       ELSE c.quantity
                       END)
    FROM cte c
    ON CONFLICT (nm_id, place_id) DO UPDATE
        SET quantity = gp.quantity + excluded.quantity;

    RETURN JSONB_BUILD_OBJECT('data',NULL);
END
$$;

