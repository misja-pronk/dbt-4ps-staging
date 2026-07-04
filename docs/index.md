# dbt-4ps-staging

Build a Databricks staging layer for **[4PS Construct](https://www.4ps.nl/)** (Microsoft Dynamics 365 Business Central) data exported with **[bc2adls](https://github.com/Bertverbeek4PS/bc2adls)** — without hand-writing a single staging model.

bc2adls exports Business Central tables as CSV deltas plus [CDM](https://learn.microsoft.com/en-us/common-data-model/) metadata describing every table and column. This project turns that metadata into a complete [dbt](https://www.getdbt.com/) staging package: one streaming table per source table, with typed columns, readable snake_case names, column documentation, and primary-key uniqueness tests.

## How it works

```
Business Central (4PS Construct)
        │  bc2adls export
        ▼
Unity Catalog volume        CSV deltas + CDM json metadata
        │  dbt-4ps-generator download / generate
        ▼
dbt staging models          SELECT ... FROM STREAM READ_FILES(...)
        │  dbt run
        ▼
Streaming tables            typed, documented, tested staging layer
```

Each generated model reads the CSV deltas for one table with Databricks `READ_FILES`, applies the column types from the CDM metadata, and renames columns like `CreditLimitLCY-20` to `credit_limit_lcy`. Models are materialized as [streaming tables](https://docs.databricks.com/aws/en/dlt/streaming-tables), so `dbt run` incrementally ingests new deltas.

## What's in the repo

| Directory | Contents |
|---|---|
| `dbt_4ps_staging_generator/` | Python CLI that reads a CDM manifest and generates the dbt models |
| `dbt_4ps_staging_package/` | The generated dbt package: 73 staging models for 4PS Construct |
| `_cdm/` | A 3-table example CDM export to try the generator |

## Next steps

- [Getting started](getting-started.md) — from bc2adls export to running staging tables
- [The generator CLI](generator.md) — `generate` and `download` reference
- [The dbt package](package.md) — configuration and day-to-day use
