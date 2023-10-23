CREATE OR REPLACE FUNCTION pharmacy.sales_upd(_src JSONB, _ch_employee_id BIGINT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
BEGIN

    WITH ins_cte AS (
        INSERT INTO pharmacy.sales AS s (sale_id,
                                         client_id,
                                         is_delivery,
                                         delivery_info,
                                         status,
                                         dt,
                                         responsible_employee_id,
                                         ch_employee_id,
                                         ch_dt)
        SELECT j.sale_id,
               j.client_id,
               j.is_delivery,
               j.delivery_info,
               j.status,
               j.dt,
               j.responsible_employee_id,
               _ch_employee_id                 AS ch_employee_id,
               _dt                             AS ch_dt
        FROM JSONB_TO_RECORD(_src) AS j (sale_id                 BIGINT,
                                         client_id               BIGINT,
                                         is_delivery             BOOLEAN,
                                         delivery_info           JSONB,
                                         status                  CHAR(3),
                                         dt                      TIMESTAMPTZ,
                                         responsible_employee_id BIGINT)
        ON CONFLICT (sale_id) DO UPDATE
            SET client_id               = excluded.client_id,
                is_delivery             = excluded.is_delivery,
                delivery_info           = excluded.delivery_info,
                status                  = excluded.status,
                dt                      = excluded.dt,
                responsible_employee_id = excluded.responsible_employee_id,
                ch_employee_id          = excluded.ch_employee_id,
                ch_dt                   = excluded.ch_dt
        RETURNING s.*)

        INSERT INTO history.sales_changes AS sc (sale_id,
                                                 client_id,
                                                 is_delivery,
                                                 delivery_info,
                                                 status,
                                                 dt,
                                                 responsible_employee_id,
                                                 ch_employee_id,
                                                 ch_dt)
        SELECT ic.sale_id,
               ic.client_id,
               ic.is_delivery,
               ic.delivery_info,
               ic.status,
               ic.dt,
               ic.responsible_employee_id,
               ic.ch_employee_id,
               ic.ch_dt
        FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;