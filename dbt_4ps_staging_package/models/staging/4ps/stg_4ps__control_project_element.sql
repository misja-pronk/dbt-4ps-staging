select
    `ProjectNo-10` as `project_no`,
    `Element-20` as `element`,
    `Description-21` as `description`,
    `Level-22` as `level`,
    `Chapter-23` as `chapter`,
    `Paragraph-24` as `paragraph`,
    `Description2-25` as `description_2`,
    `OriginalFilter-92` as `original_filter`,
    `MainProjectNo-210` as `main_project_no`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ControlProjectElement-11012048/*.csv',
        schema
        => '`ProjectNo-10` string, `Element-20` string, `Description-21` string, `Level-22` int, `Chapter-23` string, `Paragraph-24` string, `Description2-25` string, `OriginalFilter-92` string, `MainProjectNo-210` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
