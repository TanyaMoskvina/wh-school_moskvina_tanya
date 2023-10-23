CREATE OR REPLACE FUNCTION pharmacy.supplies_upd(_src  JSONB, _ch_employee_id BIGINT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
BEGIN
    WITH ins_cte AS (
        INSERT INTO pharmacy.supplies AS s (supply_id,
                                            nm_id,
                                            quantity,
                                            supplier_id,
                                            dt,
                                            is_accepted,
                                            ch_employee_id,
                                            ch_dt)
            SELECT COALESCE(s1.supply_id, NEXTVAL('pharmacy.pharmacy_sq')),
                   j.nm_id,
                   j.quantity,
                   j.supplier_id,
                   j.dt,
                   j.is_accepted,
                   _ch_employee_id,
                   _dt
            FROM JSONB_TO_RECORD(_src) AS j (supply_id   BIGINT,
                                             nm_id       BIGINT,
                                             quantity    SMALLINT,
                                             supplier_id BIGINT,
                                             dt          TIMESTAMPTZ,
                                             is_accepted BOOLEAN)
                     LEFT JOIN pharmacy.supplies s1 ON j.supply_id = s1.supply_id
            ON CONFLICT (supply_id, nm_id) DO UPDATE
                SET quantity       = s.quantity + excluded.quantity,
                    supplier_id    = excluded.supplier_id,
                    dt             = excluded.dt,
                    is_accepted    = excluded.is_accepted,
                    ch_employee_id = excluded.ch_employee_id,
                    ch_dt          = excluded.ch_dt
        RETURNING s.supply_id, s.is_accepted)

    UPDATE pharmacy.supplies s
    SET is_accepted = TRUE
    FROM ins_cte ic
    WHERE s.supply_id = ic.supply_id
      AND ic.is_accepted = TRUE;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;