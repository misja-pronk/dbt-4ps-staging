# dbt-4ps-staging

[![ci](https://github.com/misja-pronk/dbt-4ps-staging/actions/workflows/ci.yml/badge.svg)](https://github.com/misja-pronk/dbt-4ps-staging/actions/workflows/ci.yml)
[![PyPI](https://img.shields.io/pypi/v/dbt-4ps-generator.svg)](https://pypi.org/project/dbt-4ps-generator/)
[![Docs](https://img.shields.io/badge/docs-dbt--4ps--staging-blue.svg)](https://misja-pronk.github.io/dbt-4ps-staging/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)

**[Read the docs →](https://misja-pronk.github.io/dbt-4ps-staging/)**

Build a Databricks staging layer for **[4PS Construct](https://www.4ps.nl/)** (Microsoft Dynamics 365 Business Central) data exported with **[bc2adls](https://github.com/Bertverbeek4PS/bc2adls)**.

bc2adls exports Business Central tables as CSV deltas plus [CDM](https://learn.microsoft.com/en-us/common-data-model/) metadata describing every table and column. This repo turns that metadata into a complete [dbt](https://www.getdbt.com/) staging package — one streaming table per source table, with typed columns, readable snake_case names, column documentation, and primary-key uniqueness tests — so you never hand-write staging models again.

## What's in here

| Directory | Contents |
|---|---|
| [`dbt_4ps_staging_generator/`](dbt_4ps_staging_generator/) | Python CLI that reads a CDM manifest and generates the dbt models |
| [`dbt_4ps_staging_package/`](dbt_4ps_staging_package/) | The generated dbt package: 73 staging models for 4PS Construct |
| [`_cdm/`](_cdm/) | Small example CDM export (3 tables) to try the generator — see [`_cdm/README.md`](_cdm/README.md) for how to download your own |

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

## Quickstart

1. Export your Business Central tables with bc2adls to a Unity Catalog volume.
2. Generate the models (or use the pre-generated package as-is if your table set matches):

   ```bash
   uv tool install dbt-4ps-generator     # or run ephemerally with uvx

   export DATABRICKS_HOST=https://<workspace>.azuredatabricks.net
   export DATABRICKS_TOKEN=<token>
   dbt-4ps-generator download --volume-path /Volumes/<catalog>/<schema>/<volume> --output-directory ./cdm
   dbt-4ps-generator generate --manifest ./cdm/deltas.manifest.cdm.json --output-directory dbt_4ps_staging_package/models/staging/4ps
   ```

3. Configure and run the dbt package — see [dbt_4ps_staging_package/README.md](dbt_4ps_staging_package/README.md).

Full walkthrough in the [docs](https://misja-pronk.github.io/dbt-4ps-staging/getting-started/).

## Contributing

Issues and PRs are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for the
toolchain (`mise` + `uv` + `ruff`) and the day-to-day commands.

## License

[MIT](LICENSE)
