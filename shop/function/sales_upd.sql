CREATE OR REPLACE FUNCTION shop.sales_upd(_src jsonb,
                                          _employee_id integer) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          timestamptz := NOW();
    _err_message varchar(500):= 'Непредвиденная ошибка!';
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT COALESCE(s1.sales_id, NEXTVAL('shop.shop_sq')) AS sales_id,
           _dt AS dt,
           s1.client_id,
           s1.product_id,
           s1.amount,
           _employee_id AS employee_id
    FROM JSONB_TO_RECORDSET(_src) AS s1 (sales_id   int,
                                         client_id  int,
                                         product_id int,
                                         amount     int);

    SELECT CASE
               WHEN c.client_id IS NULL
                   THEN 'Такого клиента не существует'
               WHEN p.product_id IS NULL
                   THEN 'Такого товара не существует'
               WHEN t.amount <= 0
                   THEN 'Количество должно быть больше 0'
               ELSE NULL
        END
    INTO _err_message
    FROM tmp t
             LEFT JOIN shop.client c ON t.client_id = c.client_id
             LEFT JOIN shop.product p ON t.product_id = p.product_id;

    IF _err_message IS NOT NULL
    THEN
        RETURN public.errmessage(_errcode := 'shop.sales_upd.error',
                                 _msg := _err_message,
                                 _detail := NULL);
    END IF;

    INSERT INTO shop.sales AS s (sales_id,
                                 dt,
                                 client_id,
                                 product_id,
                                 amount,
                                 employee_id)
    SELECT t.sales_id,
           t.dt,
           t.client_id,
           t.product_id,
           t.amount,
           t.employee_id
    FROM tmp t
    ON CONFLICT (sales_id) DO UPDATE
        SET dt          = excluded.dt,
            client_id   = excluded.client_id,
            product_id  = excluded.product_id,
            amount      = excluded.amount,
            employee_id = excluded.employee_id;


    RETURN JSON_BUILD_OBJECT('data', NULL);
END;
$$;