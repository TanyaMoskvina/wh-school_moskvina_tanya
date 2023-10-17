CREATE OR REPLACE FUNCTION dictionary.release_forms_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _release_form_id SMALLINT;
    _name            VARCHAR(64);
BEGIN

    SELECT COALESCE(rf.release_form_id, nextval('dictionary.release_forms_release_form_id_seq')) AS release_form_id,
           s.name
    INTO _release_form_id, _name
    FROM JSONB_TO_RECORD(_src) AS s (release_form_id SMALLINT,
                                     name            VARCHAR(256))
             LEFT JOIN dictionary.release_forms rf
                 ON rf.release_form_id = s.release_form_id;

    INSERT INTO dictionary.release_forms as rf (release_form_id,
                                                name)
    SELECT _release_form_id,
           _name
    ON CONFLICT (release_form_id) DO UPDATE
        SET name = excluded.name;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;