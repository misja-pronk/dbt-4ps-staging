select
    `ProjectNo-10` as `project_no`,
    `LineNo-15` as `line_no`,
    `CustomerNo-20` as `customer_no`,
    `UnitPrice-30` as `unit_price`,
    `Description-48` as `description`,
    `PriceList-50` as `price_list`,
    `Quantity-60` as `quantity`,
    `RefDateFilter-85` as `ref_date_filter`,
    `SalesDiscount-130` as `sales_discount`,
    `SalesSurcharge-140` as `sales_surcharge`,
    `Element-200` as `element`,
    `ExtensionContractNo-210` as `extension_contract_no`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ProjectUnitPrice-11020427/*.csv',
        schema
        => '`ProjectNo-10` string, `LineNo-15` int, `CustomerNo-20` string, `UnitPrice-30` string, `Description-48` string, `PriceList-50` string, `Quantity-60` decimal(12,5), `RefDateFilter-85` string, `SalesDiscount-130` decimal(12,5), `SalesSurcharge-140` decimal(12,5), `Element-200` string, `ExtensionContractNo-210` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
