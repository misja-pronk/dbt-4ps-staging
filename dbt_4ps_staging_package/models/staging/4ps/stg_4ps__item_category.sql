select
    `Code-1` as `code`,
    `ParentCategory-2` as `parent_category`,
    `Description-3` as `description`,
    `Indentation-9` as `indentation`,
    `PresentationOrder-10` as `presentation_order`,
    `HasChildren-11` as `has_children`,
    `LastModifiedDateTime-12` as `last_modified_date_time`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/ItemCategory-5722/*.csv',
        schema
        => '`Code-1` string, `ParentCategory-2` string, `Description-3` string, `Indentation-9` int, `PresentationOrder-10` int, `HasChildren-11` boolean, `LastModifiedDateTime-12` timestamp, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
