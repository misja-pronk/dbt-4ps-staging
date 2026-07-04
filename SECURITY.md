# Security Policy

## How this project handles credentials

- **No secrets are stored in this repo.** The dbt profile reads the Databricks
  connection from `DBT_DATABRICKS_*` environment variables, and the generator's
  `download` command uses the Databricks SDK's default authentication chain
  (`DATABRICKS_HOST`/`DATABRICKS_TOKEN` or a `~/.databrickscfg` profile).
- The CDM metadata in `_cdm/` contains only table/column definitions — no data
  and no connection details.

## Supported versions

The latest commit on `main` is supported.

## Reporting a vulnerability

Please report security issues **privately**:

- Open a [GitHub Security Advisory](https://github.com/misja-pronk/dbt-4ps-staging/security/advisories/new), or
- email **misja@prorexconsultancy.nl**.
