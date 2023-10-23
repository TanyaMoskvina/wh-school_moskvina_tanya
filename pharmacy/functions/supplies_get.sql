CREATE OR REPLACE FUNCTION pharmacy.supplies_get(_supply_id BIGINT DEFAULT NULL) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT s.supply_id,
                     s.nm_id,
                     s.quantity,
                     s.supplier_id,
                     s.dt,
                     s.is_accepted,
                     s.ch_employee_id,
                     s.ch_dt
              FROM pharmacy.supplies s
              WHERE s.supply_id = COALESCE(_supply_id, s.supply_id)) res;
END
$$;

