from cdm import Argument, Attribute
from converters import (
    argument_to_option,
    attribute_to_column,
    construct_path,
    to_snake_case_with_column_number_removed,
    trait_reference_to_format,
)


class TestToSnakeCase:
    def test_removes_trailing_column_number(self):
        assert to_snake_case_with_column_number_removed("Name-2") == "name"
        assert to_snake_case_with_column_number_removed("CreditLimitLCY-20") == "credit_limit_lcy"

    def test_splits_camel_case(self):
        assert to_snake_case_with_column_number_removed("SearchName") == "search_name"
        assert (
            to_snake_case_with_column_number_removed("GlobalDimension1Code")
            == "global_dimension_1_code"
        )

    def test_acronyms(self):
        assert (
            to_snake_case_with_column_number_removed("VATRegistrationNo-86")
            == "vat_registration_no"
        )
        assert to_snake_case_with_column_number_removed("GLN-90") == "gln"

    def test_plain_word(self):
        assert to_snake_case_with_column_number_removed("timestamp") == "timestamp"


class TestTraitReferenceToFormat:
    def test_csv(self):
        assert trait_reference_to_format("is.partition.format.CSV") == "csv"

    def test_parquet(self):
        assert trait_reference_to_format("is.partition.format.parquet") == "parquet"


class TestArgumentToOption:
    def test_column_headers(self):
        option = argument_to_option(Argument(name="columnHeaders", value="true"))
        assert option.key == "header"
        assert option.value == "true"

    def test_delimiter(self):
        option = argument_to_option(Argument(name="delimiter", value=","))
        assert option.key == "sep"
        assert option.value == ","

    def test_encoding_is_uppercased(self):
        option = argument_to_option(Argument(name="encoding", value="utf-8"))
        assert option.key == "encoding"
        assert option.value == "UTF-8"

    def test_escape_backslash_is_doubled_for_sql_literal(self):
        option = argument_to_option(Argument(name="escape", value="\\"))
        assert option.key == "escape"
        assert option.value == "\\\\"

    def test_unknown_argument_passes_through(self):
        option = argument_to_option(Argument(name="quote", value='"'))
        assert option.key == "quote"
        assert option.value == '"'


def make_attribute(data_format, maximum_length=None, applied_traits=None):
    return Attribute(
        name="SomeColumn-1",
        dataFormat=data_format,
        displayName="Some Column",
        maximumLength=maximum_length,
        appliedTraits=applied_traits or [],
    )


class TestAttributeToColumn:
    def test_string(self):
        assert attribute_to_column(make_attribute("String")).type == "string"

    def test_int32(self):
        assert attribute_to_column(make_attribute("Int32")).type == "int"

    def test_int64(self):
        assert attribute_to_column(make_attribute("Int64")).type == "bigint"

    def test_boolean(self):
        assert attribute_to_column(make_attribute("Boolean")).type == "boolean"

    def test_date_and_datetime(self):
        assert attribute_to_column(make_attribute("Date")).type == "date"
        assert attribute_to_column(make_attribute("DateTime")).type == "timestamp"
        assert attribute_to_column(make_attribute("DateTimeOffset")).type == "timestamp"

    def test_guid_and_time_fall_back_to_string(self):
        assert attribute_to_column(make_attribute("Guid")).type == "string"
        assert attribute_to_column(make_attribute("Time")).type == "string"

    def test_decimal_with_precision_and_scale(self):
        traits = [
            {
                "traitReference": "is.dataFormat.numeric.shaped",
                "arguments": [{"name": "scale", "value": 5}],
            }
        ]
        column = attribute_to_column(
            make_attribute("Decimal", maximum_length=12, applied_traits=traits)
        )
        assert column.type == "decimal(12,5)"

    def test_decimal_without_scale(self):
        column = attribute_to_column(make_attribute("Decimal", maximum_length=12))
        assert column.type == "decimal(12)"

    def test_decimal_without_precision_falls_back_to_string(self):
        column = attribute_to_column(make_attribute("Decimal"))
        assert column.type == "string"

    def test_column_keeps_original_name_and_display_name(self):
        column = attribute_to_column(make_attribute("String"))
        assert column.name == "SomeColumn-1"
        assert column.display_name == "Some Column"


class TestConstructPath:
    def test_combines_volume_root_location_and_glob(self):
        path = construct_path(root_location="deltas/PaymentTerms-3", glob_pattern="/*.csv")
        assert path == (
            '/Volumes/{{ var("source")["database"] }}/{{ var("source")["schema"] }}'
            '/{{ var("source")["volume"] }}/deltas/PaymentTerms-3/*.csv'
        )
