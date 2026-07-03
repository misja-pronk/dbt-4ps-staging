select
    `ProjectNo-10` as `project_no`,
    `MainProjectNo-15` as `main_project_no`,
    `CostObject-20` as `cost_object`,
    `CostType-170` as `cost_type`,
    `CostComponent-340` as `cost_component`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ControlProjectCostObject-11012047/*.csv',
        schema
        => '`ProjectNo-10` string, `MainProjectNo-15` string, `CostObject-20` string, `CostType-170` string, `CostComponent-340` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
