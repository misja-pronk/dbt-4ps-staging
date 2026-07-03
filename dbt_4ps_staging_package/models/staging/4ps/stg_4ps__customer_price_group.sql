select
    `Code-1` as `code`,
    `PriceIncludesVAT-2` as `price_includes_vat`,
    `AllowInvoiceDisc-5` as `allow_invoice_disc`,
    `VATBusPostingGrPrice-6` as `vat_bus_posting_gr_price`,
    `Description-10` as `description`,
    `CoupledtoCRM-720` as `coupledto_crm`,
    `PriceCalculationMethod-7000` as `price_calculation_method`,
    `AllowLineDisc-7001` as `allow_line_disc`,
    `timestamp-0` as `timestamp`,
    `systemId-2000000000` as `system_id`,
    `SystemCreatedAt-2000000001` as `system_created_at`,
    `SystemCreatedBy-2000000002` as `system_created_by`,
    `SystemModifiedAt-2000000003` as `system_modified_at`,
    `SystemModifiedBy-2000000004` as `system_modified_by`,
    `$Company` as `company`,
    _metadata
from
    stream read_files(
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/CustomerPriceGroup-6/*.csv',
        schema
        => '`Code-1` string, `PriceIncludesVAT-2` boolean, `AllowInvoiceDisc-5` boolean, `VATBusPostingGrPrice-6` string, `Description-10` string, `CoupledtoCRM-720` boolean, `PriceCalculationMethod-7000` string, `AllowLineDisc-7001` boolean, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
