CREATE OR REPLACE FUNCTION humanresource.client_get_info(_phone VARCHAR(11)) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN

    IF NOT EXISTS(SELECT 1 FROM humanresource.clients c WHERE c.phone = _phone)
    THEN
        RETURN public.errmessage(_errcode := 'humanresource.client_get_info.not_exists',
                                 _msg := 'Пользователь с таким номером телефона не зарегестрирован',
                                 _detail := CONCAT('phone = ', _phone));
    END IF;

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.name,
                     c.phone,
                     c.birth_date,
                     cc.card_id,
                     CONCAT(cl.discount, '%') AS discount
              FROM humanresource.clients c
                       LEFT JOIN humanresource.clients_card cc ON c.client_id = cc.client_id
                       LEFT JOIN dictionary.card_levels cl ON cc.level_id = cl.level_id
              WHERE c.phone = _phone) res;
END
$$;