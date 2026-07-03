select
    `Code-1` as `code`,
    `Description-2` as `description`,
    `InternationalStandardCode-3` as `international_standard_code`,
    `Symbol-4` as `symbol`,
    `LastModifiedDateTime-5` as `last_modified_date_time`,
    `CoupledtoCRM-720` as `coupledto_crm`,
    `LastDateModified-11012000` as `last_date_modified`,
    `ExporttoFSA-11012990` as `exportto_fsa`,
    `DateTimeExporttoFSA-11012991` as `date_time_exportto_fsa`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/UnitofMeasure-204/*.csv',
        schema
        => '`Code-1` string, `Description-2` string, `InternationalStandardCode-3` string, `Symbol-4` string, `LastModifiedDateTime-5` timestamp, `CoupledtoCRM-720` boolean, `LastDateModified-11012000` date, `ExporttoFSA-11012990` boolean, `DateTimeExporttoFSA-11012991` timestamp, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
