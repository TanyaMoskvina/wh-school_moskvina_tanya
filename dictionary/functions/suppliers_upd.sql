CREATE OR REPLACE FUNCTION dictionary.suppliers_upd(_src JSONB, _ch_employee_id INT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH ins_cte AS (
        INSERT INTO dictionary.suppliers AS s (supplier_id,
                                               name,
                                               inn,
                                               is_active,
                                               ch_employee_id,
                                               ch_dt)
            SELECT COALESCE(s.supplier_id, NEXTVAL('humanresource.humanresource_sq')) AS supplier_id,
                   j.name,
                   j.inn,
                   j.is_active,
                   _ch_employee_id AS ch_employee_id,
                   _dt             AS ch_dt
            FROM JSONB_TO_RECORD(_src) AS j (supplier_id BIGINT,
                                             name        VARCHAR(128),
                                             inn         VARCHAR(12),
                                             is_active   BOOLEAN)
                     LEFT JOIN dictionary.suppliers s
                               ON s.supplier_id = j.supplier_id
            ON CONFLICT (supplier_id) DO UPDATE
                SET name           = excluded.name,
                    inn            = excluded.inn,
                    is_active      = excluded.is_active,
                    ch_employee_id = excluded.ch_employee_id,
                    ch_dt          = excluded.ch_dt
            RETURNING s.*)

    INSERT INTO history.suppliers_changes AS sc (supplier_id,
                                                 name,
                                                 inn,
                                                 is_active,
                                                 ch_employee_id,
                                                 ch_dt)
            SELECT ic.supplier_id,
                   ic.name,
                   ic.inn,
                   ic.is_active,
                   ic.ch_employee_id,
                   ic.ch_dt
            FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;

