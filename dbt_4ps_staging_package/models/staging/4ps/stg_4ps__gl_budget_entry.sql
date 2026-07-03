select
    `EntryNo-1` as `entry_no`,
    `BudgetName-2` as `budget_name`,
    `GLAccountNo-3` as `gl_account_no`,
    `Date-4` as `date`,
    `GlobalDimension1Code-5` as `global_dimension_1_code`,
    `GlobalDimension2Code-6` as `global_dimension_2_code`,
    `Amount-7` as `amount`,
    `Description-9` as `description`,
    `BusinessUnitCode-10` as `business_unit_code`,
    `UserID-11` as `user_id`,
    `BudgetDimension1Code-12` as `budget_dimension_1_code`,
    `BudgetDimension2Code-13` as `budget_dimension_2_code`,
    `BudgetDimension3Code-14` as `budget_dimension_3_code`,
    `BudgetDimension4Code-15` as `budget_dimension_4_code`,
    `LastDateModified-16` as `last_date_modified`,
    `DimensionSetID-480` as `dimension_set_id`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/GLBudgetEntry-96/*.csv',
        schema
        => '`EntryNo-1` int, `BudgetName-2` string, `GLAccountNo-3` string, `Date-4` date, `GlobalDimension1Code-5` string, `GlobalDimension2Code-6` string, `Amount-7` decimal(12,5), `Description-9` string, `BusinessUnitCode-10` string, `UserID-11` string, `BudgetDimension1Code-12` string, `BudgetDimension2Code-13` string, `BudgetDimension3Code-14` string, `BudgetDimension4Code-15` string, `LastDateModified-16` date, `DimensionSetID-480` int, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
