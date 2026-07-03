select
    `Usage-1` as `usage`,
    `Sequence-2` as `sequence`,
    `ReportID-3` as `report_id`,
    `CustomReportLayoutCode-7` as `custom_report_layout_code`,
    `UseforEmailAttachment-19` as `usefor_email_attachment`,
    `UseforEmailBody-20` as `usefor_email_body`,
    `EmailBodyLayoutCode-21` as `email_body_layout_code`,
    `EmailBodyLayoutType-25` as `email_body_layout_type`,
    `EmailBodyLayoutName-26` as `email_body_layout_name`,
    `EmailBodyLayoutAppID-27` as `email_body_layout_app_id`,
    `ReportLayoutName-30` as `report_layout_name`,
    `ReportLayoutAppID-31` as `report_layout_app_id`,
    `Description-11012000` as `description`,
    `NoRequestForm-11012550` as `no_request_form`,
    `PrinterSelection-11012560` as `printer_selection`,
    `DefaultSelection-11012562` as `default_selection`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ReportSelections-77/*.csv',
        schema
        => '`Usage-1` string, `Sequence-2` string, `ReportID-3` int, `CustomReportLayoutCode-7` string, `UseforEmailAttachment-19` boolean, `UseforEmailBody-20` boolean, `EmailBodyLayoutCode-21` string, `EmailBodyLayoutType-25` string, `EmailBodyLayoutName-26` string, `EmailBodyLayoutAppID-27` string, `ReportLayoutName-30` string, `ReportLayoutAppID-31` string, `Description-11012000` string, `NoRequestForm-11012550` boolean, `PrinterSelection-11012560` boolean, `DefaultSelection-11012562` boolean, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
