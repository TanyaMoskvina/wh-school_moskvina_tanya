CREATE OR REPLACE FUNCTION dictionary.release_form_getall() RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT pt.place_type_id,
                     pt.name
              FROM dictionary.place_types pt) res;
END
$$;

