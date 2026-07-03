# dbt_4ps_staging_generator

CLI that generates dbt staging models from a [bc2adls](https://github.com/Bertverbeek4PS/bc2adls) CDM export. For every entity in the manifest it writes:

- `stg_4ps__<table>.sql` — a `SELECT ... FROM STREAM READ_FILES(...)` model with the column types from the CDM metadata and columns renamed to snake_case (`CreditLimitLCY-20` → `credit_limit_lcy`)
- `_4ps__models.yaml` — model + column descriptions, and a `dbt_utils.unique_combination_of_columns` test on each table's primary key

## Usage

Requires [uv](https://docs.astral.sh/uv/) and Python 3.13+.

Download the CDM metadata from the Unity Catalog volume bc2adls exports to (authenticates via `DATABRICKS_HOST`/`DATABRICKS_TOKEN` or a `~/.databrickscfg` profile):

```bash
uv run python main.py download \
  --volume-path /Volumes/<catalog>/<schema>/<volume> \
  --output-directory ../_cdm
```

Generate the models:

```bash
uv run python main.py generate \
  --manifest ../_cdm/deltas.manifest.cdm.json \
  --output-directory ../dbt_4ps_staging_package/models/staging/4ps
```

Options (see `--help`): `--model-prefix` (default `stg_4ps__`), `--schema-prefix` (default `_4ps__`), and `--no-file-metadata-column` to omit the `_metadata` source-file column.

## Development

```bash
uv sync
uv run pytest
```

## Layout

| File | Purpose |
|---|---|
| `main.py` | Typer CLI (`generate`, `download`) |
| `cdm.py` | Pydantic models for the CDM manifest and entity files |
| `converters.py` | CDM → dbt/SQL conversions (types, names, READ_FILES options) |
| `dbt.py` | Builders that write the .sql models and schema yaml |
| `sql.py` | SQL primitives (columns, options, streaming-table DDL builder) |
| `databricks_helper.py` | Volume download via the Databricks SDK |
