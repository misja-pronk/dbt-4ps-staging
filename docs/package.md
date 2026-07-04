# The dbt package

`dbt_4ps_staging_package/` contains 73 generated staging models for 4PS Construct, materialized as [streaming tables](https://docs.databricks.com/aws/en/dlt/streaming-tables) with column documentation and a primary-key uniqueness test per table.

!!! warning "Generated code"
    Don't hand-edit the models under `models/staging/4ps/` — change the generator and regenerate. CI verifies the committed models stay in sync with the generator's output for the example entities.

## Configuration

Two vars locate your data (override in `dbt_project.yml` or with `--vars`):

```yaml
vars:
  source:        # Unity Catalog volume holding the bc2adls export
    database: my_catalog
    schema: bc2adls
    volume: bc2adls_deltas
  destination:   # where the streaming tables are created
    database: my_catalog
    schema: staging
```

The bundled `profiles.yml` reads the warehouse connection from environment variables:

| Variable | Example |
|---|---|
| `DBT_DATABRICKS_HOST` | `adb-1234567890.10.azuredatabricks.net` |
| `DBT_DATABRICKS_HTTP_PATH` | `/sql/1.0/warehouses/<warehouse-id>` |
| `DBT_DATABRICKS_CATALOG` | `my_catalog` |
| `DBT_DATABRICKS_TOKEN` | a personal access token |

## Day-to-day

```sh
uv sync
uv run dbt deps --profiles-dir .
uv run dbt run --profiles-dir .    # incremental refresh of the streaming tables
uv run dbt test --profiles-dir .   # primary-key uniqueness tests
```

Streaming tables require a SQL warehouse or serverless compute. `READ_FILES` tracks which delta files were already ingested, so `dbt run` only processes new exports.

## Regenerating for your table set

If your bc2adls export covers different tables, regenerate the models from your own manifest — see [the generator CLI](generator.md). Existing models for unchanged tables regenerate byte-identically.
