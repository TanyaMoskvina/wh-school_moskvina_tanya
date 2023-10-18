CREATE OR REPLACE FUNCTION whsync.prices_sync_export(_log_id BIGINT) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _dt  TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _res JSONB;
BEGIN
    DELETE
    FROM whsync.prices_sync ps
    WHERE ps.log_id <= _log_id
      AND ps.sync_dt IS NOT NULL;

    WITH sync_cte AS (
        SELECT ps.log_id,
               ps.nm_id,
               ps.price,
               ps.ch_employee_id,
               ps.ch_dt,
               ps.sync_dt
        FROM whsync.prices_sync ps
        ORDER BY ps.log_id
        LIMIT 1000)

       , cte_upd AS (
           UPDATE whsync.prices_sync ps
               SET sync_dt = _dt
               FROM sync_cte sc
               WHERE ps.log_id = sc.log_id)

    SELECT JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(sc)))
    INTO _res
    FROM sync_cte sc;

    RETURN _res;
END
$$;