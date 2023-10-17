CREATE OR REPLACE FUNCTION dictionary.goods_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO dictionary.goods AS g (nm_id,
                                       name,
                                       by_prescription,
                                       dosage,
                                       count_in_pack,
                                       release_form_id,
                                       category_id,
                                       manufacturer_id)
    SELECT COALESCE(g.nm_id, NEXTVAL('pharmacy.pharmacy_sq')) AS nm_id,
           s.name,
           s.by_prescription,
           s.dosage,
           s.count_in_pack,
           s.release_form_id,
           s.category_id,
           s.manufacturer_id
    FROM JSONB_TO_RECORD(_src) AS s (nm_id           BIGINT,
                                     name            VARCHAR(256),
                                     by_prescription BOOLEAN,
                                     dosage          VARCHAR(16),
                                     count_in_pack   SMALLINT,
                                     release_form_id SMALLINT,
                                     category_id     SMALLINT,
                                     manufacturer_id INT)
             LEFT JOIN dictionary.goods g ON g.nm_id = s.nm_id
    ON CONFLICT (nm_id) DO UPDATE
        SET name            = excluded.name,
            by_prescription = excluded.by_prescription,
            dosage          = excluded.dosage,
            count_in_pack   = excluded.count_in_pack,
            release_form_id = excluded.release_form_id,
            category_id     = excluded.category_id,
            manufacturer_id = excluded.manufacturer_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;