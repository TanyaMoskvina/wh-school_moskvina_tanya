CREATE OR REPLACE FUNCTION pharmacy.places_get_by_id(_place_id BIGINT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _count_children SMALLINT;
BEGIN
    SELECT CASE
               WHEN p.place_type_id = 4
                   THEN (SELECT SUM(gp.quantity) FROM pharmacy.goods_on_place gp WHERE gp.place_id = _place_id)
               ELSE
                    (SELECT COUNT(*) FROM pharmacy.places p WHERE p.parent_place_id = _place_id)
               END
    INTO _count_children
    FROM pharmacy.places p
    WHERE p.place_id = _place_id;

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.place_id,
                     p.max_children,
                     _count_children AS count_children,
                     p.max_children - _count_children AS free_space
              FROM pharmacy.places p
              WHERE p.place_id = _place_id) res;
END
$$;

