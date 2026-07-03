select
    `EntryNo-1` as `entry_no`,
    `ParentEntryNo-2` as `parent_entry_no`,
    `SiblingSequenceNo-3` as `sibling_sequence_no`,
    `PresentationOrder-4` as `presentation_order`,
    `Indentation-5` as `indentation`,
    `Description-6` as `description`,
    `AccountCategory-7` as `account_category`,
    `IncomeBalance-8` as `income_balance`,
    `AdditionalReportDefinition-9` as `additional_report_definition`,
    `SystemGenerated-11` as `system_generated`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/GLAccountCategory-570/*.csv',
        schema
        => '`EntryNo-1` int, `ParentEntryNo-2` int, `SiblingSequenceNo-3` int, `PresentationOrder-4` string, `Indentation-5` int, `Description-6` string, `AccountCategory-7` string, `IncomeBalance-8` string, `AdditionalReportDefinition-9` string, `SystemGenerated-11` boolean, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
