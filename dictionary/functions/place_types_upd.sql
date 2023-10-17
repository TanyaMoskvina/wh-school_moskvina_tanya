CREATE OR REPLACE FUNCTION dictionary.place_types_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _place_type_id SMALLINT;
    _name          VARCHAR(32);
BEGIN

    SELECT COALESCE(pt.place_type_id, nextval('dictionary.place_types_place_type_id_seq')) AS place_type_id,
           s.name
    INTO _place_type_id, _name
    FROM JSONB_TO_RECORD(_src) AS s (place_type_id SMALLINT,
                                     name          VARCHAR(256))
             LEFT JOIN dictionary.place_types pt
                 ON pt.place_type_id = s.place_type_id;

    INSERT INTO dictionary.place_types as pt (place_type_id,
                                              name)
    SELECT _place_type_id,
           _name
    ON CONFLICT (place_type_id) DO UPDATE
        SET name = excluded.name;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;