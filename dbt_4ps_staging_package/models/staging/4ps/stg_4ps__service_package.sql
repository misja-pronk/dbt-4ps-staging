select
    `Code-10` as `code`,
    `Description-20` as `description`,
    `SourceType-30` as `source_type`,
    `ServicePackageContract-40` as `service_package_contract`,
    `ServicePackageCall-41` as `service_package_call`,
    `ServicePackageDirect-42` as `service_package_direct`,
    `ServicePackageEstimate-43` as `service_package_estimate`,
    `SelectforMaintSalesRate-50` as `selectfor_maint_sales_rate`,
    `ServiceCategory-60` as `service_category`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ServicePackage-11012806/*.csv',
        schema
        => '`Code-10` string, `Description-20` string, `SourceType-30` string, `ServicePackageContract-40` string, `ServicePackageCall-41` string, `ServicePackageDirect-42` string, `ServicePackageEstimate-43` string, `SelectforMaintSalesRate-50` boolean, `ServiceCategory-60` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
