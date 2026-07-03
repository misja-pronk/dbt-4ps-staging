select
    `ProjectNo-10` as `project_no`,
    `ProgressDate-20` as `progress_date`,
    `DepartmentCode-25` as `department_code`,
    `Comment-30` as `comment`,
    `Text-50` as `text`,
    `TechnicalFinished-60` as `technical_finished`,
    `ProgressFixed-70` as `progress_fixed`,
    `MostRecent-80` as `most_recent`,
    `Createdby-100` as `createdby`,
    `Createdon-101` as `createdon`,
    `Modifiedby-105` as `modifiedby`,
    `Modifiedon-106` as `modifiedon`,
    `HideLabTotBudgetH0-110` as `hide_lab_tot_budget_h_0`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ProgressLevel-11012036/*.csv',
        schema
        => '`ProjectNo-10` string, `ProgressDate-20` date, `DepartmentCode-25` string, `Comment-30` string, `Text-50` string, `TechnicalFinished-60` boolean, `ProgressFixed-70` boolean, `MostRecent-80` boolean, `Createdby-100` string, `Createdon-101` date, `Modifiedby-105` string, `Modifiedon-106` date, `HideLabTotBudgetH0-110` boolean, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
