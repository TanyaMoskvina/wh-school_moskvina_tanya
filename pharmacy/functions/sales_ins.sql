CREATE OR REPLACE FUNCTION pharmacy.sales_ins(_src JSONB, _goods JSONB, _ch_employee_id BIGINT) RETURNS JSONB
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
        SELECT NEXTVAL('pharmacy.pharmacy_sq') AS sale_id,
               j.client_id,
               j.is_delivery,
               j.delivery_info,
               j.status,
               _dt                             AS dt,
               j.responsible_employee_id,
               _ch_employee_id                 AS ch_employee_id,
               _dt                             AS ch_dt
        FROM JSONB_TO_RECORD(_src) AS j (client_id               BIGINT,
                                         is_delivery             BOOLEAN,
                                         delivery_info           JSONB,
                                         status                  CHAR(3),
                                         responsible_employee_id BIGINT)
        RETURNING s.*)

/*    , ins_his AS (
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
        FROM ins_cte ic)*/

    , goods AS (
        SELECT ic.sale_id,
               g.nm_id,
               g.quantity
        FROM JSONB_TO_RECORDSET(_goods) AS g (nm_id    BIGINT,
                                              quantity SMALLINT),
            ins_cte ic)

    , ins_sale_items AS (
        INSERT INTO pharmacy.sale_items AS si (sale_id,
                                               nm_id,
                                               quantity,
                                               total_price)
        SELECT ic.sale_id,
               g.nm_id,
               g.quantity,
               ROUND((SELECT CASE
                                 WHEN ic.client_id IS NULL
                                     THEN g.quantity * p.price
                                 ELSE g.quantity * (p.price - p.price * cl.discount / 100::NUMERIC)
                                 END
               ), 2) AS total_price
        FROM ins_cte ic
                 LEFT JOIN humanresource.clients_card cc ON ic.client_id = cc.client_id
                 LEFT JOIN dictionary.card_levels cl ON cc.level_id = cl.level_id
                 LEFT JOIN goods g ON ic.sale_id = g.sale_id
                 LEFT JOIN pharmacy.prices p ON g.nm_id = p.nm_id
        RETURNING si.total_price)

    , upd_cte AS (
        UPDATE humanresource.clients_card cc
        SET amount_spent = cc.amount_spent + (SELECT SUM(si.total_price) FROM ins_sale_items si),
            level_id = (SELECT CASE
                                   WHEN cc.level_id <= (SELECT MAX(cl.level_id) FROM dictionary.card_levels cl) AND
                                       (cc.amount_spent + (SELECT SUM(si.total_price) FROM ins_sale_items si)) >= cl.amount_spent
                                       THEN cc.level_id + 1
                                   ELSE cc.level_id
                                   END
                        FROM dictionary.card_levels cl
                        WHERE cl.level_id = cc.level_id)
        FROM ins_cte ic
        WHERE cc.client_id = ic.client_id)

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