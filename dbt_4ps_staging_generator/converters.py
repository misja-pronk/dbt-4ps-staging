import re

from cdm import Argument, Attribute
from sql import Column, Option


def to_snake_case_with_column_number_removed(input_string):
    # Remove trailing hyphen + digits first
    input_string = re.sub(r"[-_]\d+$", "", input_string)

    # Find all words correctly
    words = re.findall(
        r"(?:[A-Z]+(?=[A-Z][a-z]))|(?:[A-Z]?[a-z]+)|(?:[A-Z]+)|(?:\d+)", input_string
    )

    # Join with underscores and lowercase
    to_snake_case = "_".join(map(str.lower, words))
    return to_snake_case


def trait_reference_to_format(trait_reference: str):
    return trait_reference.split(".")[-1].lower()


def argument_to_option(argument: Argument) -> Option:
    match argument.name:
        case "columnHeaders":
            return Option(key="header", value=argument.value)

        case "delimiter":
            return Option(key="sep", value=argument.value)

        case "encoding":
            return Option(key="encoding", value=argument.value.upper())

        case "escape":
            # double backslashes so the value survives SQL string-literal parsing
            return Option(key="escape", value=argument.value.replace("\\", "\\\\"))
        case _:
            return Option(key=argument.name, value=argument.value)


def attribute_to_column(attribute: Attribute) -> Column:
    match attribute.data_format.lower():
        case "string":
            type = "string"
        case "int32":
            type = "int"
        case "decimal":
            precision = None
            scale = None

            if attribute.maximum_length:
                precision = attribute.maximum_length

            for applied_trait in attribute.applied_traits:
                if applied_trait.trait_reference == "is.dataFormat.numeric.shaped":
                    for argument in applied_trait.arguments:
                        if argument["name"] == "scale":
                            scale = argument["value"]
                        break

            if precision and scale:
                type = f"decimal({precision},{scale})"
            elif precision:
                type = f"decimal({precision})"
            else:
                type = "string"

        case "double":
            type = "double"
        case "option":
            type = "string"
        case "int64":
            type = "bigint"
        case "boolean":
            type = "boolean"
        case "integer" | "interger":  # tolerate the misspelled variant seen in some exports
            type = "int"
        case "time":
            type = "string"
        case "code":
            type = "string"
        case "date":
            type = "date"
        case "datetime":
            type = "timestamp"
        case "datetimeoffset":
            type = "timestamp"
        case "duration":
            type = "string"
        case "guid":
            type = "string"
        case _:
            type = "string"

    return Column(
        name=attribute.name,
        type=type,
        display_name=attribute.display_name,
        is_primary_key=attribute.is_primary_key,
    )


def construct_path(root_location: str, glob_pattern: str) -> str:
    volume = (
        r'/Volumes/{{ var("source")["database"] }}'
        r'/{{ var("source")["schema"] }}/{{ var("source")["volume"] }}'
    )
    return f"{volume}/{root_location}{glob_pattern}"
