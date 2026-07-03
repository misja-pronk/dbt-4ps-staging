select
    `EntryNo-1` as `entry_no`,
    `TimeSheetNo-2` as `time_sheet_no`,
    `TimeSheetLineNo-3` as `time_sheet_line_no`,
    `TimeSheetDate-4` as `time_sheet_date`,
    `Quantity-5` as `quantity`,
    `DocumentNo-6` as `document_no`,
    `PostingDate-7` as `posting_date`,
    `Description-10` as `description`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/TimeSheetPostingEntry-958/*.csv',
        schema
        => '`EntryNo-1` int, `TimeSheetNo-2` string, `TimeSheetLineNo-3` int, `TimeSheetDate-4` date, `Quantity-5` decimal(12,5), `DocumentNo-6` string, `PostingDate-7` date, `Description-10` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
