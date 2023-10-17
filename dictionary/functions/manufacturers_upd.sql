CREATE OR REPLACE FUNCTION dictionary.manufacturers_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _manufacturer_id SMALLINT;
    _name            VARCHAR(256);
    _country         VARCHAR(32);
BEGIN

    SELECT COALESCE(m.manufacturer_id, nextval('dictionary.manufacturers_manufacturer_id_seq')) AS manufacturer_id,
           s.name,
           s.country
    INTO _manufacturer_id, _name, _country
    FROM JSONB_TO_RECORD(_src) AS s (manufacturer_id SMALLINT,
                                     name            VARCHAR(256),
                                     country         VARCHAR(32))
             LEFT JOIN dictionary.manufacturers m
                 ON m.manufacturer_id = s.manufacturer_id;

    INSERT INTO dictionary.manufacturers as m (manufacturer_id,
                                               name,
                                               country)
    SELECT _manufacturer_id,
           _name,
           _country
    ON CONFLICT (manufacturer_id) DO UPDATE
        SET name    = excluded.name,
            country = excluded.country;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;