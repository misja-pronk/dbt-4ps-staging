select
    `ProjectNo-1` as `project_no`,
    `No-2` as `no`,
    `Description-3` as `description`,
    `Modifiedby-4` as `modifiedby`,
    `LastDateModified-5` as `last_date_modified`,
    `VersionDate-14` as `version_date`,
    `Inputby-20` as `inputby`,
    `InputDate-21` as `input_date`,
    `Text-30` as `text`,
    `BudgetCorrectionFixed-40` as `budget_correction_fixed`,
    `CorrectionFixed-45` as `correction_fixed`,
    `CreatedfromPurchaseAction-50` as `createdfrom_purchase_action`,
    `BudgetAdjustmentType-60` as `budget_adjustment_type`,
    `CreatedfromSourceType-80` as `createdfrom_source_type`,
    `CreatedfromScheduleDate-90` as `createdfrom_schedule_date`,
    `CreatedfromLineNo-100` as `createdfrom_line_no`,
    `PhaseChangeElement-110` as `phase_change_element`,
    `OriginalElementPhaseCode-120` as `original_element_phase_code`,
    `NewElementPhaseCode-130` as `new_element_phase_code`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/BudgetAdjustment-11012003/*.csv',
        schema
        => '`ProjectNo-1` string, `No-2` string, `Description-3` string, `Modifiedby-4` string, `LastDateModified-5` date, `VersionDate-14` date, `Inputby-20` string, `InputDate-21` date, `Text-30` string, `BudgetCorrectionFixed-40` boolean, `CorrectionFixed-45` boolean, `CreatedfromPurchaseAction-50` string, `BudgetAdjustmentType-60` string, `CreatedfromSourceType-80` string, `CreatedfromScheduleDate-90` date, `CreatedfromLineNo-100` int, `PhaseChangeElement-110` string, `OriginalElementPhaseCode-120` string, `NewElementPhaseCode-130` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
