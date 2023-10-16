CREATE OR REPLACE FUNCTION humanresource.employees_upd(_src JSONB, _ch_employee_id INT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _employee_id BIGINT;
    _phone       VARCHAR(11);
    _name        VARCHAR(64);
    _birth_date  DATE;
    _rank_id     SMALLINT;
    _is_deleted  BOOLEAN;
    _dt          TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
BEGIN

    SELECT COALESCE(e.employee_id, NEXTVAL('humanresource.humanresource_sq')) AS employee_id,
           s.phone,
           s.name,
           s.birth_date,
           s.rank_id,
           s.is_deleted
    INTO _employee_id, _phone, _name, _birth_date, _rank_id, _is_deleted
    FROM JSONB_TO_RECORD(_src) AS s (employee_id BIGINT,
                                     phone       VARCHAR(11),
                                     name        VARCHAR(64),
                                     birth_date  DATE,
                                     rank_id     SMALLINT,
                                     is_deleted  BOOLEAN)
             LEFT JOIN humanresource.employees e
                       ON e.employee_id = s.employee_id;

    WITH ins_cte AS (
        INSERT INTO humanresource.employees AS e (employee_id,
                                                  phone,
                                                  name,
                                                  birth_date,
                                                  rank_id,
                                                  is_deleted,
                                                  ch_employee_id,
                                                  ch_dt)
            SELECT _employee_id    AS employee_id,
                   _phone          AS phone,
                   _name           AS name,
                   _birth_date     AS birth_date,
                   _rank_id        AS rank_id,
                   _is_deleted     AS is_deleted,
                   _ch_employee_id AS ch_employee_id,
                   _dt             AS ch_dt
            ON CONFLICT (employee_id) DO UPDATE
                SET phone          = excluded.phone,
                    name           = excluded.name,
                    birth_date     = excluded.birth_date,
                    rank_id        = excluded.rank_id,
                    is_deleted     = excluded.is_deleted,
                    ch_employee_id = excluded.ch_employee_id,
                    ch_dt          = excluded.ch_dt
            RETURNING e.*)

    INSERT INTO history.employees_changes AS ec (employee_id,
                                                 phone,
                                                 name,
                                                 birth_date,
                                                 rank_id,
                                                 is_deleted,
                                                 ch_employee_id,
                                                 ch_dt)
           SELECT ic.employee_id,
                  ic.phone,
                  ic.name,
                  ic.birth_date,
                  ic.rank_id,
                  ic.is_deleted,
                  ic.ch_employee_id,
                  ic.ch_dt
           FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;

