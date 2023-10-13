CREATE OR REPLACE FUNCTION humanresource.clients_upd(_src JSONB, _ch_employee_id INT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _client_id      BIGINT;
    _phone          VARCHAR(11);
    _name           VARCHAR(64);
    _birth_date     DATE;
    _dt             TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
    _start_level_id SMALLINT    := 1;
BEGIN

    SELECT COALESCE(c.client_id, NEXTVAL('humanresource.humanresource_sq')) AS client_id,
           s.phone,
           s.name,
           s.birth_date
    INTO _client_id, _phone, _name, _birth_date
    FROM JSONB_TO_RECORD(_src) AS s (client_id  BIGINT,
                                     phone      VARCHAR(11),
                                     name       VARCHAR(64),
                                     birth_date DATE)
             LEFT JOIN humanresource.clients c
                       ON c.client_id = s.client_id;

    WITH ins_cte AS (
        INSERT INTO humanresource.clients AS c (client_id,
                                                phone,
                                                name,
                                                birth_date,
                                                ch_employee_id,
                                                ch_dt)
            SELECT _client_id      AS client_id,
                   _phone          AS phone,
                   _name           AS name,
                   _birth_date     AS birth_date,
                   _ch_employee_id AS ch_employee_id,
                   _dt             AS dt
            ON CONFLICT (client_id) DO UPDATE
                SET phone          = excluded.phone,
                    name           = excluded.name,
                    birth_date     = excluded.birth_date,
                    ch_employee_id = excluded.ch_employee_id,
                    ch_dt          = excluded.ch_dt
            RETURNING c.*)

       , ins_crd AS (
        INSERT INTO humanresource.clients_card AS ccr (card_id,
                                                       client_id,
                                                       level_id,
                                                       ch_employee_id,
                                                       ch_dt)
            SELECT NEXTVAL('humanresource.humanresource_sq') AS card_id,
                   ic.client_id,
                   _start_level_id                           AS level_id,
                   ic.ch_employee_id,
                   ic.ch_dt
            FROM ins_cte ic
                     LEFT JOIN humanresource.clients_card cc ON ic.client_id = cc.client_id
            WHERE cc.card_id IS NULL)

    INSERT INTO history.clients_changes AS cch (client_id,
                                                phone,
                                                name,
                                                birth_date,
                                                ch_employee_id,
                                                ch_dt)
    SELECT ic.client_id,
           ic.phone,
           ic.name,
           ic.birth_date,
           ic.ch_employee_id,
           ic.ch_dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;

