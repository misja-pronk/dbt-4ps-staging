select
    `Code-10` as `code`,
    `Description-20` as `description`,
    `SearchName-30` as `search_name`,
    `DefaultCostObjectPurchase-35` as `default_cost_object_purchase`,
    `BudgetAdjustmentType-36` as `budget_adjustment_type`,
    `ResponsibleEmployee-40` as `responsible_employee`,
    `Text-50` as `text`,
    `DocumentTemplate-110` as `document_template`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/PurchaseAction-11012025/*.csv',
        schema
        => '`Code-10` string, `Description-20` string, `SearchName-30` string, `DefaultCostObjectPurchase-35` string, `BudgetAdjustmentType-36` string, `ResponsibleEmployee-40` string, `Text-50` string, `DocumentTemplate-110` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
