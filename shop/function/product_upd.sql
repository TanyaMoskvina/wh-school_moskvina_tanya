CREATE OR REPLACE FUNCTION shop.product_upd(_data JSON, _employee_id INT) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt          TIMESTAMPTZ = NOW();
    _err_message VARCHAR(500);
BEGIN
    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT s.product_id,
           s.name,
           s.price,
           _dt          AS dt,
           _employee_id AS employee_id
    FROM JSON_TO_RECORDSET(_data) AS s (
                                        product_id INT,
                                        name VARCHAR(30),
                                        price NUMERIC(10, 2),
                                        dt TIMESTAMPTZ,
                                        employee_id INT
        );
    SELECT CASE
               WHEN t.employee_id IS NULL
                   THEN 'Не переданы обязательные параметры'
               WHEN t.price <= 0
                   THEN 'Цена не может быть отрицательной'
               END
    INTO _err_message
    FROM tmp t;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('product_upd.empty_params_or_p_negative', _err_message, NULL);
    END IF;

    IF EXISTS(SELECT 1
              FROM shop.product st
                       JOIN tmp t ON (st.product_id =  t.product_id AND t.name = st.name AND t.price = st.price) OR
                                     (st.product_id <> t.product_id AND t.name = st.name))
    THEN
        RETURN public.errmessage('product_upd.duplicate', 'Такая запись уже есть', NULL);
    END IF;

    INSERT INTO shop.product AS ins (product_id, name, price, dt, employee_id)
    SELECT t.product_id,
           t.name,
           t.price,
           t.dt,
           t.employee_id
    FROM tmp t
    ON CONFLICT (product_id) DO UPDATE
        SET name        = excluded.name,
            price       = excluded.price,
            employee_id = excluded.employee_id
    WHERE ins.dt < excluded.dt;
    RETURN JSON_BUILD_OBJECT('data', NULL);
END;
$$;