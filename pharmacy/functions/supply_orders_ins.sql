CREATE OR REPLACE FUNCTION pharmacy.supply_orders_ins(_src  JSONB, _employee_id BIGINT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt TIMESTAMPTZ := NOW() AT TIME ZONE 'Europe/Moscow';
BEGIN
    INSERT INTO pharmacy.supply_orders AS so (supply_order_id,
                                              supplier_id,
                                              order_info,
                                              responsible_employee_id,
                                              dt)
        SELECT NEXTVAL('pharmacy.pharmacy_sq') AS supply_order_id,
               j.supplier_id,
               j.order_info,
               _employee_id                    AS responsible_employee_id,
               _dt                             AS dt
        FROM JSONB_TO_RECORD(_src) AS j (supplier_id BIGINT,
                                         order_info  JSONB);

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;