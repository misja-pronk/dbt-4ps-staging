# dbt-4ps-generator

[![PyPI](https://img.shields.io/pypi/v/dbt-4ps-generator.svg)](https://pypi.org/project/dbt-4ps-generator/)

CLI that generates dbt staging models from a [bc2adls](https://github.com/Bertverbeek4PS/bc2adls) CDM export. For every entity in the manifest it writes:

- `stg_4ps__<table>.sql` — a `SELECT ... FROM STREAM READ_FILES(...)` model with the column types from the CDM metadata and columns renamed to snake_case (`CreditLimitLCY-20` → `credit_limit_lcy`)
- `_4ps__models.yaml` — model + column descriptions, and a `dbt_utils.unique_combination_of_columns` test on each table's primary key

Full documentation: <https://misja-pronk.github.io/dbt-4ps-staging/>

## Install

```bash
uvx dbt-4ps-generator --help          # run once, ephemerally
uv tool install dbt-4ps-generator     # install the command on PATH
```

Or from a checkout: `uv run dbt-4ps-generator` in this directory.

## Usage

Download the CDM metadata from the Unity Catalog volume bc2adls exports to (authenticates via `DATABRICKS_HOST`/`DATABRICKS_TOKEN` or a `~/.databrickscfg` profile):

```bash
dbt-4ps-generator download \
  --volume-path /Volumes/<catalog>/<schema>/<volume> \
  --output-directory ../_cdm
```

Generate the models:

```bash
dbt-4ps-generator generate \
  --manifest ../_cdm/deltas.manifest.cdm.json \
  --output-directory ../dbt_4ps_staging_package/models/staging/4ps
```

Options (see `--help`): `--model-prefix` (default `stg_4ps__`), `--schema-prefix` (default `_4ps__`), and `--no-file-metadata-column` to omit the `_metadata` source-file column.

## Development

```bash
uv sync
uv run pytest
uv run ruff check . && uv run ruff format --check .
uv run ty check
```

## Layout

| File (`src/dbt_4ps_generator/`) | Purpose |
|---|---|
| `cli.py` | Typer CLI (`generate`, `download`) |
| `cdm.py` | Pydantic models for the CDM manifest and entity files |
| `converters.py` | CDM → dbt/SQL conversions (types, names, READ_FILES options) |
| `dbt.py` | Builders that write the .sql models and schema yaml |
| `sql.py` | SQL primitives (columns, options, streaming-table DDL builder) |
| `databricks_helper.py` | Volume download via the Databricks SDK |
