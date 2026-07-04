from collections.abc import Callable
from pathlib import Path
from typing import Self

import yaml
from sqlfmt.api import Mode, format_string
from sqlfmt.exception import SqlfmtError

from sql import Column, Option


class ModelBuilder:
    def __init__(self):
        self._name: str = None
        self._columns: list[Column] = []
        self._path: Path = None
        self._options: list[Option] = []
        self._format: str = None
        self._rename_function: Callable[[str], str] = lambda x: x
        self._add_file_metadata_column: bool = False
        self._description: str = None
        self._output_directory: Path = None
        self._prefix: str = None

    def add_rename_function(self, rename_function: Callable[[str], str]) -> Self:
        self._rename_function = rename_function
        return self

    def get_rename_function(self) -> Callable[[str], str]:
        return self._rename_function

    def add_file_metadata_column(self, add_file_metadata_column: bool = True) -> Self:
        self._add_file_metadata_column = add_file_metadata_column
        return self

    def name(self, name: str, prefix=None) -> Self:
        self._name = name
        self._prefix = prefix
        return self

    def output_directory(self, output_directory: Path) -> Self:
        self._output_directory = output_directory
        return self

    def description(self, description: str) -> Self:
        self._description = description
        return self

    def format(self, format: str) -> Self:
        if format not in [
            "avro",
            "binaryFile",
            "csv",
            "json",
            "orc",
            "parquet",
            "text",
            "xml",
        ]:
            raise Exception(
                f"Invalid format: {format} allowed only: "
                "avro, binaryFile, csv, json, orc, parquet, text, or xml"
            )

        self._format = format
        return self

    def add_column(self, column: Column) -> Self:
        self._columns.append(column)
        return self

    def add_columns(self, columns: list[Column]) -> Self:
        self._columns.extend(columns)
        return self

    def get_columns(self) -> list[Column]:
        return self._columns

    def add_option(self, option: Option) -> Self:
        self._options.append(option)
        return self

    def add_options(self, options: list[Option]) -> Self:
        self._options.extend(options)
        return self

    def get_name(self) -> str:
        if self._prefix:
            return f"{self._prefix}{self._rename_function(self._name)}"
        else:
            return self._rename_function(self._name)

    def get_description(self) -> str:
        return self._description

    def path(self, path: str) -> Self:
        self._path = path
        return self

    def get_column_names(
        self, filter_function: Callable[[Column], bool] = lambda c: True
    ) -> list[str]:
        return [c.name for c in self._columns if filter_function(c)]

    def get_column_display_names(self) -> list[str]:
        return [c.display_name for c in self._columns]

    def get_renamed_column_names(
        self, filter_function: Callable[[Column], bool] = lambda c: True
    ) -> list[str]:
        column_names = self.get_column_names(filter_function=filter_function)
        renamed_column_names = []

        for column_name in column_names:
            _renamed_column = self._rename_function(column_name)
            if _renamed_column in renamed_column_names:
                renamed_column_names.append(
                    f"{_renamed_column}_{renamed_column_names.count(_renamed_column)}"
                )
            else:
                renamed_column_names.append(_renamed_column)

        return renamed_column_names

    def _select_list(self) -> str:
        select_list = [
            f"`{c}` as `{rc}`"
            for c, rc in zip(self.get_column_names(), self.get_renamed_column_names(), strict=True)
        ]

        if self._add_file_metadata_column:
            select_list.append("_metadata")

        if select_list:
            return ", ".join(select_list)
        else:
            return "*"

    def _read_files(self) -> str:
        _path = self._path
        _schema = f"schema => '{', '.join([f'`{c.name}` {c.type}' for c in self._columns])}'"
        _options = ", ".join([f"{o.key} => '{o.value}'" for o in self._options])
        _read_files = f"READ_FILES('{_path}', {_schema}, {_options})"
        return _read_files

    def build(self) -> Self:
        mode = Mode()
        data = f"SELECT {self._select_list()} FROM STREAM {self._read_files()}"
        try:
            formatted_query = format_string(data, mode)
        except SqlfmtError as e:
            print(f"Could not format {self.get_name()}, writing unformatted sql: {e}")
            formatted_query = data

        path = self._output_directory / Path(f"{self.get_name()}.sql")
        path.write_text(data=formatted_query)
        return self


class ModelsSchemaBuilder:
    def __init__(self):
        self._name: str = None
        self._model_builders: list[ModelBuilder] = []
        self._output_directory: Path = None
        self._prefix: str = None

    def name(self, name: str, prefix=None) -> Self:
        self._name = name
        self._prefix = prefix
        return self

    def get_name(self) -> str:
        if self._prefix:
            return f"{self._prefix}{self._name}"
        else:
            return self._name

    def add_model_builder(self, model_builder: ModelBuilder) -> Self:
        self._model_builders.append(model_builder)
        return self

    def add_model_builders(self, model_builders: list[ModelBuilder]) -> Self:
        self._model_builders.extend(model_builders)
        return self

    def output_directory(self, output_directory: Path) -> Self:
        self._output_directory = output_directory
        return self

    def build(self) -> Self:
        models = []

        for model_builder in self._model_builders:
            primary_key_columns = model_builder.get_renamed_column_names(
                filter_function=lambda c: c.is_primary_key
            )
            tests = []

            if primary_key_columns:
                tests.append(
                    {
                        "dbt_utils.unique_combination_of_columns": {
                            "combination_of_columns": primary_key_columns
                        }
                    }
                )

            columns = [
                {
                    "name": name,
                    "description": description,
                }
                for name, description in zip(
                    model_builder.get_renamed_column_names(),
                    model_builder.get_column_display_names(),
                    strict=True,
                )
            ]

            model = {
                "name": model_builder.get_name(),
                "description": model_builder.get_description(),
                "config": {
                    "database": r'{{ var("destination")["database"] }}',
                    "schema": r'{{ var("destination")["schema"] }}',
                    "materialized": "streaming_table",
                },
                "columns": columns,
            }
            if tests:
                model["data_tests"] = tests
            models.append(model)

        data = {"version": 2, "models": models}

        path = self._output_directory / Path(f"{self.get_name()}.yaml")
        path.write_text(
            data=yaml.dump(
                data,
                sort_keys=False,  # Keep key order
                default_flow_style=False,  # Use block style (not inline)
                indent=3,
            )
        )
        return self
