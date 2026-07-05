# The example dbt project

`example_dbt_project/` is a minimal, working dbt project that shows how to wire generated 4PS staging models into dbt. It ships three sample models (`payment_terms`, `currency`, `customer`) generated from the example CDM export in `_cdm/`, materialized as [streaming tables](https://docs.databricks.com/aws/en/dlt/streaming-tables) with column documentation and a primary-key uniqueness test each.

!!! important "This is a starting point, not a shippable package"
    Every 4PS Construct environment exports a different set of tables, so there is no universal model set. Copy this project, regenerate the models for *your* tables, and commit the result to your own repo.

## Generate models for your tables

Point the [generator](generator.md) at your bc2adls CDM manifest and write into the project's `models/staging/4ps/` directory — this replaces the sample models:

```sh
uvx dbt-4ps-generator generate \
  --manifest /path/to/your/deltas.manifest.cdm.json \
  --output-directory example_dbt_project/models/staging/4ps
```

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

!!! note "Don't hand-edit generated models"
    Change the generator and regenerate rather than editing the `.sql` under `models/staging/4ps/`. CI regenerates the sample models from `_cdm/` and diffs them against what's committed here, so the example doubles as an integration test.
