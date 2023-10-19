CREATE OR REPLACE FUNCTION dictionary.release_form_getall() RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT rf.release_form_id,
                     rf.name
              FROM dictionary.release_forms rf) res;
END
$$;

