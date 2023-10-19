CREATE OR REPLACE FUNCTION whsync.clients_sync_import(_src JSONB) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    WITH cte AS (SELECT DISTINCT ON (s.client_id)
                        s.client_id,
                        s.phone,
                        s.name,
                        s.birth_date,
                        s.ch_employee_id,
                        s.ch_dt
                 FROM JSONB_TO_RECORDSET(_src) AS s (client_id      BIGINT,
                                                     phone          VARCHAR(11),
                                                     name           VARCHAR(64),
                                                     birth_date     DATE,
                                                     ch_employee_id BIGINT,
                                                     ch_dt          TIMESTAMPTZ)
                 ORDER BY s.client_id, s.ch_dt DESC)

    INSERT INTO humanresource.clients AS c (client_id,
                                            phone,
                                            name,
                                            birth_date,
                                            ch_employee_id,
                                            ch_dt)
    SELECT ct.client_id,
           ct.phone,
           ct.name,
           ct.birth_date,
           ct.ch_employee_id,
           ct.ch_dt
    FROM cte ct
    ON CONFLICT (client_id) DO UPDATE
        SET phone          = excluded.phone,
            name           = excluded.name,
            birth_date     = excluded.birth_date,
            ch_employee_id = excluded.ch_employee_id,
            ch_dt          = excluded.ch_dt
    WHERE c.ch_dt < excluded.ch_dt;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;