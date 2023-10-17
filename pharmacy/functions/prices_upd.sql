CREATE OR REPLACE FUNCTION pharmacy.prices_upd(_src JSONB, _ch_employee_id INT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nm_id BIGINT;
    _price NUMERIC(10, 2);
    _dt    TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
BEGIN

    SELECT s.nm_id,
           s.price
    INTO _nm_id, _price
    FROM JSONB_TO_RECORD(_src) AS s (nm_id BIGINT,
                                     price NUMERIC(10, 2));

    WITH ins_cte AS (
        INSERT INTO pharmacy.prices AS p (nm_id,
                                          price,
                                          ch_employee_id,
                                          ch_dt)
            SELECT _nm_id,
                   _price,
                   _ch_employee_id,
                   _dt
            ON CONFLICT (nm_id) DO UPDATE
                SET price          = excluded.price,
                    ch_employee_id = excluded.ch_employee_id,
                    ch_dt          = excluded.ch_dt
            RETURNING p.*)

    INSERT INTO history.prices_changes AS pc (nm_id,
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

