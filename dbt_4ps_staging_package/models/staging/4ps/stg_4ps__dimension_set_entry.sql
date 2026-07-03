select
    `DimensionSetID-1` as `dimension_set_id`,
    `DimensionCode-2` as `dimension_code`,
    `DimensionValueCode-3` as `dimension_value_code`,
    `DimensionValueID-4` as `dimension_value_id`,
    `GlobalDimensionNo-8` as `global_dimension_no`,
    `CompanyFilter-11012000` as `company_filter`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/DimensionSetEntry-480/*.csv',
        schema
        => '`DimensionSetID-1` int, `DimensionCode-2` string, `DimensionValueCode-3` string, `DimensionValueID-4` int, `GlobalDimensionNo-8` int, `CompanyFilter-11012000` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
