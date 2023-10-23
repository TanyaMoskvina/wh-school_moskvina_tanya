CREATE OR REPLACE FUNCTION dictionary.goods_getinfo(_nm_id BIGINT DEFAULT NULL) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT g.nm_id,
                     g.name,
                     g.by_prescription,
                     g.dosage,
                     g.count_in_pack,
                     rf.name AS release_form,
                     gc.name AS category,
                     m.name AS manufacturer,
                     p.price
              FROM dictionary.goods g
                    LEFT JOIN dictionary.release_forms rf ON g.release_form_id = rf.release_form_id
                    LEFT JOIN dictionary.goods_category gc ON g.category_id = gc.category_id
                    LEFT JOIN dictionary.manufacturers m ON g.manufacturer_id = m.manufacturer_id
                    LEFT JOIN pharmacy.prices p ON g.nm_id = p.nm_id
              WHERE g.nm_id = COALESCE(_nm_id, g.nm_id)) res;
END
$$;

