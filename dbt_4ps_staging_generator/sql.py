from pydantic import BaseModel
from typing import Self, List, Union
from pathlib import Path


class Option(BaseModel):
    key: str
    value: str

    def to_sql(self) -> str:
        return f"{self.key} => '{self.value}'"


class RowFilter(BaseModel):
    func_name: str
    other_column_names: List[str]

    def to_sql(self) -> str:
        _row_filter = (
            f"ROW FILTER {self.func_name} ON ({', '.join(self.other_column_names)})"
        )
        return _row_filter


class Mask(BaseModel):
    func_name: str
    other_column_names: List[str] = []

    def to_sql(self) -> str:
        _mask = f"MASK {self.func_name}"
        if self.other_column_names:
            _mask += f" USING COLUMNS ({', '.join(self.other_column_names)})"
        return _mask


class Property:
    def __init__(self, key: str, value: Union[bool, str, int, float]):
        self.key = key
        self.value = value

    def to_sql(self) -> str:
        if isinstance(self.value, bool):
            _value = "true" if self.value else "false"
        elif isinstance(self.value, str):
            _value = f"'{self.value}'"
        else:
            _value = str(self.value)

        return f"'{self.key}' = {_value}"


class Column(BaseModel):
    name: str
    display_name: str = None
    type: str
    is_nullable: bool = True
    comment: str = None
    mask: Mask = None
    is_primary_key: bool = False

    def to_sql(self) -> str:
        _column = f"`{self.name}` {self.type}"

        if not self.is_nullable:
            _column += " NOT NULL"

        if self.comment:
            _column += f" COMMENT '{self.comment}'"

        if self.mask:
            _column += f" {self.mask.to_sql()}"

        return _column


class Schedule:
    def __init__(
        self,
        cron_string=None,
        timezone_id=None,
        time_unit: str = None,
        integer_value: int = None,
    ):
        self.cron_string = cron_string
        self.timezone_id = timezone_id
        self.time_unit = time_unit
        self.integer_value = integer_value

    def to_sql(self) -> str:
        _schedule = ""
        if self.cron_string:
            _schedule += f"CRON {self.cron_string}"
            if self.timezone_id:
                _schedule += f" AT TIME ZONE {self.timezone_id}"
        elif self.time_unit and self.integer_value:
            _schedule += f"EVERY {self.integer_value} {self.time_unit}"
        else:
            raise Exception(
                "Either cron_string or time_unit and integer_value must be provided!"
            )

        return _schedule


class StreamingTableBuilder:
    def __init__(self):
        self._name: str = None
        self._comment: str = None
        self._columns: List[Column] = []
        self._properties: List[Property] = []
        self._clustered_by: List[str] = []
        self._schedule: Schedule = None
        self._path: Path = None
        self._options: List[Option] = []
        self._row_filter: List[RowFilter] = None
        self._format: str = None

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
                f"Invalid format: {format} allowed only: avro, binaryFile, csv, json, orc, parquet, text, or xml"
            )

        self._format = format
        return self

    def add_column(self, column: Column) -> Self:
        self._columns.append(column)
        return self

    def add_columns(self, columns: list[Column]) -> Self:
        self._columns.extend(columns)
        return self

    def add_option(self, option: Option) -> Self:
        self._options.append(option)
        return self

    def add_options(self, options: List[Option]) -> Self:
        self._options.extend(options)
        return self

    def path(self, path: str) -> Self:
        self._path = path
        return self

    def clustered_by(self, columns: list[str]) -> Self:
        self._clustered_by = columns
        return self

    def schedule(self, schedule: Schedule) -> Self:
        self._schedule = schedule
        return self

    def name(self, name: str) -> Self:
        self._name = name
        return self

    def add_property(self, property: Property) -> Self:
        self._properties.append(property)
        return self

    def add_properties(self, properties: List[Property]) -> Self:
        self._properties.extend(properties)
        return self

    def _table_specification(self) -> str:
        _table_specification = f"({', '.join([c.to_sql() for c in self._columns])})"
        return _table_specification

    def add_row_filter(self, func_name: str, columns: List[str] = []) -> Self:
        _columns = ", ".join(columns)
        _row_filer = f"ROW FILTER {func_name} ON ({_columns})"
        self._row_filter = _row_filer
        return self

    def _table_clauses(self) -> str:
        _table_clauses = ""

        if self._clustered_by:
            _table_clauses += f" CLUSTER BY ({', '.join(self._clustered_by)})"
        else:
            _table_clauses += " CLUSTER BY AUTO"

        if self._comment:
            _table_clauses += f" COMMENT '{self._comment}'"

        if self._properties:
            _table_clauses += (
                f" WITH ({', '.join(p.to_sql() for p in self._properties)})"
            )

        if self._schedule:
            _table_clauses += f" SCHEDULE REFRESH {self._schedule.to_sql()}"

        if self._row_filter:
            _table_clauses += f" WITH {self._row_filter}"

        return _table_clauses

    def _query(self) -> str:
        _path = self._path
        _schema = (
            f"schema => '{', '.join([f'`{c.name}` {c.type}' for c in self._columns])}'"
        )
        _options = ", ".join([o.to_sql() for o in self._options])
        _query = f"SELECT * FROM STREAM READ_FILES('{_path}', {_schema}, {_options})"
        return _query

    def comment(self, comment: str) -> Self:
        self._comment = comment
        return self

    def build(self) -> str:
        _streaming_table = f"CREATE OR REFRESH STREAMING TABLE `{self._name}` {self._table_specification()} {self._table_clauses()} AS {self._query()}"
        return _streaming_table
