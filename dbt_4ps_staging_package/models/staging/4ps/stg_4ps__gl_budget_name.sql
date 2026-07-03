select
    `Name-1` as `name`,
    `Description-2` as `description`,
    `Blocked-3` as `blocked`,
    `BudgetDimension1Code-4` as `budget_dimension_1_code`,
    `BudgetDimension2Code-5` as `budget_dimension_2_code`,
    `BudgetDimension3Code-6` as `budget_dimension_3_code`,
    `BudgetDimension4Code-7` as `budget_dimension_4_code`,
    `BudgetResponsible-11012000` as `budget_responsible`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/GLBudgetName-95/*.csv',
        schema
        => '`Name-1` string, `Description-2` string, `Blocked-3` boolean, `BudgetDimension1Code-4` string, `BudgetDimension2Code-5` string, `BudgetDimension3Code-6` string, `BudgetDimension4Code-7` string, `BudgetResponsible-11012000` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
