select
    `Code-1` as `code`,
    `Name-2` as `name`,
    `Commission-3` as `commission`,
    `PrivacyBlocked-150` as `privacy_blocked`,
    `CoupledtoCRM-720` as `coupledto_crm`,
    `GlobalDimension1Code-5050` as `global_dimension_1_code`,
    `GlobalDimension2Code-5051` as `global_dimension_2_code`,
    `EMail-5052` as `e_mail`,
    `PhoneNo-5053` as `phone_no`,
    `JobTitle-5062` as `job_title`,
    `SearchEMail-5085` as `search_e_mail`,
    `EMail2-5086` as `e_mail_2`,
    `Blocked-5087` as `blocked`,
    `FaxNo-11012001` as `fax_no`,
    `ReferenceICM-11012002` as `reference_icm`,
    `MobilePhoneNo-11012010` as `mobile_phone_no`,
    `StrategicPurchaser-11012020` as `strategic_purchaser`,
    `CollectPurchaseProposal-11012030` as `collect_purchase_proposal`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/SalespersonPurchaser-13/*.csv',
        schema
        => '`Code-1` string, `Name-2` string, `Commission-3` decimal(12,5), `PrivacyBlocked-150` boolean, `CoupledtoCRM-720` boolean, `GlobalDimension1Code-5050` string, `GlobalDimension2Code-5051` string, `EMail-5052` string, `PhoneNo-5053` string, `JobTitle-5062` string, `SearchEMail-5085` string, `EMail2-5086` string, `Blocked-5087` boolean, `FaxNo-11012001` string, `ReferenceICM-11012002` string, `MobilePhoneNo-11012010` string, `StrategicPurchaser-11012020` boolean, `CollectPurchaseProposal-11012030` string, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
