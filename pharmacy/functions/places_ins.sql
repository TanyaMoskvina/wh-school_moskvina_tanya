CREATE OR REPLACE FUNCTION pharmacy.places_ins(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _place_id        BIGINT;
    _parent_place_id BIGINT;
    _place_type_id   INT;
    _max_children    SMALLINT;
    _count           SMALLINT;
BEGIN
    SELECT NEXTVAL('pharmacy.pharmacy_sq') AS place_id,
           s.parent_place_id,
           s.place_type_id,
           s.max_children
    INTO _place_id, _parent_place_id, _place_type_id, _max_children
    FROM JSONB_TO_RECORD(_src) AS s (parent_place_id BIGINT,
                                     place_type_id   INT,
                                     max_children    SMALLINT);

    SELECT COUNT(*)
    INTO _count
    FROM pharmacy.places p
    WHERE p.parent_place_id = _parent_place_id;

    IF _count = (SELECT p.max_children FROM pharmacy.places p WHERE p.place_id = _parent_place_id)
    THEN
        RETURN public.errmessage(_errcode := 'pharmacy.places_ins.place.there_is_no_place',
                                 _msg     := CONCAT('Это место уже заполнено'),
                                 _detail  := CONCAT('place_id = ', _parent_place_id, ', max_children = ', _count));
    END IF;

    INSERT INTO pharmacy.places AS p (place_id,
                                      parent_place_id,
                                      place_type_id,
                                      max_children)
    SELECT _place_id,
           _parent_place_id,
           _place_type_id,
           _max_children;

    RETURN JSONB_BUILD_OBJECT('place_id', _place_id);
END
$$;

