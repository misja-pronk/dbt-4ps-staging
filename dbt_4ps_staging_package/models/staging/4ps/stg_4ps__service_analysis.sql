select
    `AnalysisType-10` as `analysis_type`,
    `Code-20` as `code`,
    `Description-30` as `description`,
    `ExpectedHours-40` as `expected_hours`,
    `PublishonSubcontrPortal-50` as `publishon_subcontr_portal`,
    `Priority-60` as `priority`,
    `LastDateModified-70` as `last_date_modified`,
    `PublishonServicePortal-80` as `publishon_service_portal`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ServiceAnalysis-11012842/*.csv',
        schema
        => '`AnalysisType-10` string, `Code-20` string, `Description-30` string, `ExpectedHours-40` decimal(12,5), `PublishonSubcontrPortal-50` boolean, `Priority-60` string, `LastDateModified-70` date, `PublishonServicePortal-80` boolean, `ExporttoFSA-11012990` boolean, `DateTimeExporttoFSA-11012991` timestamp, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
