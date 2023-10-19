CREATE OR REPLACE FUNCTION dictionary.manufacturers_getall() RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT m.manufacturer_id,
                     m.name,
                     m.country
              FROM dictionary.manufacturers m) res;
END
$$;

