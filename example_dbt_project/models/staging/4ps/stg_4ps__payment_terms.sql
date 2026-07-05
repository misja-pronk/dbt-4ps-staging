select
    `Code-1` as `code`,
    `DueDateCalculation-2` as `due_date_calculation`,
    `DiscountDateCalculation-3` as `discount_date_calculation`,
    `Discount-4` as `discount`,
    `Description-5` as `description`,
    `CalcPmtDisconCrMemos-6` as `calc_pmt_discon_cr_memos`,
    `LastModifiedDateTime-8` as `last_modified_date_time`,
    `CoupledtoCRM-720` as `coupledto_crm`,
    `DiscountDateCalculation2-11012000` as `discount_date_calculation_2`,
    `Discount2-11012001` as `discount_2`,
    `DiscountDateCalculation3-11012002` as `discount_date_calculation_3`,
    `Discount3-11012003` as `discount_3`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/PaymentTerms-3/*.csv',
        schema
        => '`Code-1` string, `DueDateCalculation-2` string, `DiscountDateCalculation-3` string, `Discount-4` decimal(12,5), `Description-5` string, `CalcPmtDisconCrMemos-6` boolean, `LastModifiedDateTime-8` timestamp, `CoupledtoCRM-720` boolean, `DiscountDateCalculation2-11012000` string, `Discount2-11012001` decimal(12,5), `DiscountDateCalculation3-11012002` string, `Discount3-11012003` decimal(12,5), `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
