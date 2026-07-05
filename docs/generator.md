# The generator CLI

`dbt-4ps-generator` reads a bc2adls CDM manifest and writes dbt staging models. Install it with `uv tool install dbt-4ps-generator`, run it ephemerally with `uvx dbt-4ps-generator`, or from a checkout with `uv run dbt-4ps-generator` inside `dbt_4ps_staging_generator/`.

## `generate`

```sh
dbt-4ps-generator generate \
  --manifest _cdm/deltas.manifest.cdm.json \
  --output-directory example_dbt_project/models/staging/4ps
```

For every entity in the manifest it writes:

- **`stg_4ps__<table>.sql`** — a `SELECT ... FROM STREAM READ_FILES(...)` model with the column types from the CDM metadata and columns renamed to snake_case (`CreditLimitLCY-20` → `credit_limit_lcy`)
- **`_4ps__models.yaml`** — model + column descriptions, and a `dbt_utils.unique_combination_of_columns` test on each table's primary key

| Option | Default | Purpose |
|---|---|---|
| `--manifest` | required | Path to `deltas.manifest.cdm.json`; entity files are resolved relative to it |
| `--output-directory` | required | Where the `.sql` models and schema yaml are written |
| `--model-prefix` | `stg_4ps__` | Prefix for generated model names |
| `--schema-name` | `models` | Base name of the schema yaml |
| `--schema-prefix` | `_4ps__` | Prefix for the schema yaml |
| `--file-metadata-column / --no-file-metadata-column` | on | Add the `_metadata` column (source file info) to every model |

## `download`

```sh
dbt-4ps-generator download \
  --volume-path /Volumes/<catalog>/<schema>/<volume> \
  --output-directory ./cdm
```

Downloads all `.json` files (the manifest and entity definitions) from the Unity Catalog volume bc2adls exports to. Authentication uses the Databricks SDK's default chain: set `DATABRICKS_HOST` and `DATABRICKS_TOKEN`, or use a profile from `~/.databrickscfg` (`DATABRICKS_CONFIG_PROFILE`).

## Type mapping

CDM `dataFormat` values map to Databricks SQL types:

| CDM | SQL |
|---|---|
| `String`, `Guid`, `Time`, `Duration` | `string` |
| `Int32` | `int` |
| `Int64` | `bigint` |
| `Decimal` | `decimal(precision,scale)` from the CDM traits, falling back to `string` when precision is missing |
| `Boolean` | `boolean` |
| `Date` | `date` |
| `DateTime`, `DateTimeOffset` | `timestamp` |

Unknown formats fall back to `string`.
