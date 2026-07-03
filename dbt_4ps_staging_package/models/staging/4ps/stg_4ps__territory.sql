select
    `Code-1` as `code`,
    `Name-2` as `name`,
    `BaseCalendarCode-11012000` as `base_calendar_code`,
    `ExporttoFSA-11012990` as `exportto_fsa`,
    `DateTimeExporttoFSA-11012991` as `date_time_exportto_fsa`,
    `EventType-11013000` as `event_type`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/Territory-286/*.csv',
        schema
        => '`Code-1` string, `Name-2` string, `BaseCalendarCode-11012000` string, `ExporttoFSA-11012990` boolean, `DateTimeExporttoFSA-11012991` timestamp, `EventType-11013000` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
