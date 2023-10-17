CREATE OR REPLACE FUNCTION dictionary.card_levels_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _level_id     SMALLINT;
    _discount     SMALLINT;
    _amount_spent NUMERIC(8, 2);
BEGIN

    SELECT COALESCE(cl.level_id, nextval('dictionary.card_levels_level_id_seq')) AS level_id,
           s.discount,
           s.amount_spent
    INTO _level_id, _discount, _amount_spent
    FROM JSONB_TO_RECORD(_src) AS s (level_id     SMALLINT,
                                     discount     SMALLINT,
                                     amount_spent NUMERIC(8, 2))
             LEFT JOIN dictionary.card_levels cl
                 ON cl.level_id = s.level_id;

    INSERT INTO dictionary.card_levels as cl (level_id,
                                             discount,
                                             amount_spent)
    SELECT _level_id,
           _discount,
           _amount_spent
    ON CONFLICT (level_id) DO UPDATE
        SET discount     = excluded.discount,
            amount_spent = excluded.amount_spent;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;