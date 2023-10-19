CREATE OR REPLACE FUNCTION dictionary.suppliers_getall() RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT s.supplier_id,
                     s.name,
                     s.inn,
                     s.is_active
              FROM dictionary.suppliers s) res;
END
$$;

