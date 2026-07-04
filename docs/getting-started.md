# Getting started

From a bc2adls export to running staging tables in four steps.

## 1. Export from Business Central

Set up [bc2adls](https://github.com/Bertverbeek4PS/bc2adls) to export your 4PS Construct tables to a Unity Catalog volume. Alongside the CSV deltas it writes CDM json files (`deltas.manifest.cdm.json` plus one `<Table>-<id>.cdm.json` per table) — those are the generator's input.

## 2. Download the CDM metadata

Install the generator (or run it from a checkout — see [the generator CLI](generator.md)):

```sh
uv tool install dbt-4ps-generator
```

Authenticate via the Databricks SDK's default chain (`DATABRICKS_HOST` / `DATABRICKS_TOKEN`, or a `~/.databrickscfg` profile), then:

```sh
dbt-4ps-generator download \
  --volume-path /Volumes/<catalog>/<schema>/<volume> \
  --output-directory ./cdm
```

!!! tip "No Business Central at hand?"
    The repo ships a 3-table example export in `_cdm/` so you can try everything without an environment. See [CDM metadata](cdm-metadata.md).

## 3. Generate the models

```sh
dbt-4ps-generator generate \
  --manifest ./cdm/deltas.manifest.cdm.json \
  --output-directory dbt_4ps_staging_package/models/staging/4ps
```

This writes one `stg_4ps__<table>.sql` per entity plus a `_4ps__models.yaml` with descriptions and primary-key uniqueness tests. If your table set matches the 73 tables in the bundled package, you can skip this step and use the package as-is.

## 4. Configure and run dbt

Point the package at your environment and run it — see [the dbt package](package.md) for the vars and environment variables:

```sh
cd dbt_4ps_staging_package
export DBT_DATABRICKS_HOST=<workspace>.azuredatabricks.net
export DBT_DATABRICKS_HTTP_PATH=/sql/1.0/warehouses/<warehouse-id>
export DBT_DATABRICKS_CATALOG=<catalog>
export DBT_DATABRICKS_TOKEN=<token>

uv sync
uv run dbt deps --profiles-dir .
uv run dbt run --profiles-dir .
uv run dbt test --profiles-dir .
```

Each `dbt run` triggers an incremental refresh: new deltas are ingested, already-processed files are skipped.
