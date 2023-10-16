CREATE OR REPLACE FUNCTION humanresource.client_getinfo(_phone VARCHAR(11)) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.name,
                     c.phone,
                     c.birth_date,
                     cc.card_id,
                     cc.level_id,
                     cl.discount
              FROM humanresource.clients c
                       LEFT JOIN humanresource.clients_card cc ON c.client_id = cc.client_id
                       LEFT JOIN dictionary.card_levels cl ON cc.level_id = cl.level_id
              WHERE c.phone = _phone) res;
END
$$;