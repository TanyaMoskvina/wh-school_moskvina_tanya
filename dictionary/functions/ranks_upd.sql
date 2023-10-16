CREATE OR REPLACE FUNCTION dictionary.ranks_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _rank_id SMALLINT;
    _name    VARCHAR(32);
    _salary  NUMERIC(10, 2);
BEGIN

    SELECT COALESCE(r.rank_id, NEXTVAL('dictionary.ranks_rank_id_seq')) AS rank_id,
           s.name,
           s.salary
    INTO _rank_id, _name, _salary
    FROM JSONB_TO_RECORD(_src) AS s (rank_id SMALLINT,
                                     name    VARCHAR(32),
                                     salary  NUMERIC(10, 2))
             LEFT JOIN dictionary.ranks r
                       ON r.rank_id = s.rank_id;

    IF EXISTS(SELECT r.name FROM dictionary.ranks r
              WHERE r.name = _name AND _rank_id IS NULL)
    THEN
        RETURN public.errmessage(_errcode := 'dictionary.ranks_upd.name_exists',
                                 _msg := 'Такая должность уже существует',
                                 _detail := CONCAT('name = ', _name));
    END IF;

    INSERT INTO dictionary.ranks as r (rank_id,
                                       name,
                                       salary)
    SELECT _rank_id,
           _name,
           _salary
    ON CONFLICT (rank_id) DO UPDATE
        SET name   = excluded.name,
            salary = excluded.salary;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;