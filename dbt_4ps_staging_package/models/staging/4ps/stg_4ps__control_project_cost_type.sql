select
    `ProjectNo-10` as `project_no`,
    `CostType-20` as `cost_type`,
    `CostTypePurchaseLine-180` as `cost_type_purchase_line`,
    `MainProjectNo-300` as `main_project_no`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ControlProjectCostType-11012046/*.csv',
        schema
        => '`ProjectNo-10` string, `CostType-20` string, `CostTypePurchaseLine-180` string, `MainProjectNo-300` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
