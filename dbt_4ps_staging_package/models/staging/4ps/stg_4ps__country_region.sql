select
    `Code-1` as `code`,
    `Name-2` as `name`,
    `ISOCode-4` as `iso_code`,
    `ISONumericCode-5` as `iso_numeric_code`,
    `EUCountryRegionCode-6` as `eu_country_region_code`,
    `IntrastatCode-7` as `intrastat_code`,
    `AddressFormat-8` as `address_format`,
    `ContactAddressFormat-9` as `contact_address_format`,
    `VATScheme-10` as `vat_scheme`,
    `LastModifiedDateTime-11` as `last_modified_date_time`,
    `CountyName-12` as `county_name`,
    `SEPAAllowed-11400` as `sepa_allowed`,
    `VATBusPostingGroup-11012000` as `vat_bus_posting_group`,
    `VATBusPostingGroupEU-11012010` as `vat_bus_posting_group_eu`,
    `VATBusPostingGroupImpExp-11012020` as `vat_bus_posting_group_imp_exp`,
    `UseTNTPostKIXCode-11012030` as `use_tnt_post_kix_code`,
    `PhoneNumberFormatting-11012040` as `phone_number_formatting`,
    `POPCodeMandatory-11012050` as `pop_code_mandatory`,
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
        '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}/deltas/CountryRegion-9/*.csv',
        schema
        => '`Code-1` string, `Name-2` string, `ISOCode-4` string, `ISONumericCode-5` string, `EUCountryRegionCode-6` string, `IntrastatCode-7` string, `AddressFormat-8` string, `ContactAddressFormat-9` string, `VATScheme-10` string, `LastModifiedDateTime-11` timestamp, `CountyName-12` string, `SEPAAllowed-11400` boolean, `VATBusPostingGroup-11012000` string, `VATBusPostingGroupEU-11012010` string, `VATBusPostingGroupImpExp-11012020` string, `UseTNTPostKIXCode-11012030` boolean, `PhoneNumberFormatting-11012040` string, `POPCodeMandatory-11012050` boolean, `timestamp-0` bigint, `systemId-2000000000` string, `SystemCreatedAt-2000000001` timestamp, `SystemCreatedBy-2000000002` string, `SystemModifiedAt-2000000003` timestamp, `SystemModifiedBy-2000000004` string, `$Company` string',
        header => 'true',
        sep => ',',
        escape => '\\',
        encoding => 'UTF-8',
        quote => '"'
    )
