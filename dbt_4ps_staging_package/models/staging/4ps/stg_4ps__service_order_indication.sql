select
    `Indication-5` as `indication`,
    `Code-10` as `code`,
    `Description-20` as `description`,
    `Colour-30` as `colour`,
    `ExpectedHours-40` as `expected_hours`,
    `CostComponent-50` as `cost_component`,
    `ServiceCategory-60` as `service_category`,
    `FlowFSA-100` as `flow_fsa`,
    `LastDateModified-110` as `last_date_modified`,
    `CostComponentPlant-120` as `cost_component_plant`,
    `ExporttoFSA-11012990` as `exportto_fsa`,
    `DateTimeExporttoFSA-11012991` as `date_time_exportto_fsa`,
    `EventtypeinResourcePlanning-11124900` as `eventtypein_resource_planning`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ServiceOrderIndication-11012837/*.csv',
        schema
        => '`Indication-5` string, `Code-10` string, `Description-20` string, `Colour-30` string, `ExpectedHours-40` decimal(12,5), `CostComponent-50` string, `ServiceCategory-60` string, `FlowFSA-100` string, `LastDateModified-110` date, `CostComponentPlant-120` string, `ExporttoFSA-11012990` boolean, `DateTimeExporttoFSA-11012991` timestamp, `EventtypeinResourcePlanning-11124900` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
