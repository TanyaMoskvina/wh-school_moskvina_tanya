CREATE OR REPLACE FUNCTION pharmacy.prices_upd(_src JSONB, _ch_employee_id BIGINT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH ins_cte AS (
        INSERT INTO pharmacy.prices AS p (nm_id,
                                          price,
                                          ch_employee_id,
                                          ch_dt)
            SELECT s.nm_id,
                   s.price,
                   _ch_employee_id AS ch_employee_id,
                   _dt             AS ch_dt
            FROM JSONB_TO_RECORD(_src) AS s (nm_id BIGINT,
                                             price NUMERIC(10, 2))
            ON CONFLICT (nm_id) DO UPDATE
                SET price          = excluded.price,
                    ch_employee_id = excluded.ch_employee_id,
                    ch_dt          = excluded.ch_dt
            RETURNING p.*)

       , ins_his AS (
        INSERT INTO history.prices_changes AS pc (nm_id,
                                                  price,
                                                  ch_employee_id,
                                                  ch_dt)
            SELECT ic.nm_id,
                   ic.price,
                   ic.ch_employee_id,
                   ic.ch_dt
            FROM ins_cte ic)


    INSERT INTO whsync.prices_sync AS ps (nm_id,
                                          price,
                                          ch_employee_id,
                                          ch_dt)
        SELECT ic.nm_id,
               ic.price,
               ic.ch_employee_id,
               ic.ch_dt
        FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;