CREATE OR REPLACE FUNCTION pharmacy.goods_on_place_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nm_id    BIGINT;
    _place_id BIGINT;
    _quantity SMALLINT;
    _is_taken BOOLEAN;
BEGIN
    SELECT s.nm_id,
           s.place_id,
           s.quantity,
           s.is_taken
    INTO _nm_id, _place_id, _quantity, _is_taken
    FROM JSONB_TO_RECORD(_src) AS s (nm_id    BIGINT,
                                     place_id BIGINT,
                                     quantity SMALLINT,
                                     is_taken BOOLEAN);

    IF _is_taken
    THEN
        _quantity = - _quantity;
    END IF;

    INSERT INTO pharmacy.goods_on_place AS gp (nm_id,
                                               place_id,
                                               quantity)
    SELECT _nm_id,
           _place_id,
           _quantity
    ON CONFLICT (nm_id, place_id) DO UPDATE
        SET quantity = gp.quantity + excluded.quantity;

    RETURN JSONB_BUILD_OBJECT('data',NULL);
END
$$;

