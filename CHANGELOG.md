# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Ruff lint + format for the generator, with a CI job enforcing both.
- CI job verifying the committed models stay in sync with the generator.
- `mise` tasks for the common workflows (`test`, `lint`, `fmt`, `check`,
  `generate`, `dbt:parse`).
- Contributing guide, security policy, issue/PR templates.

## [0.1.0] - 2026-07-04

Initial public release.

### Added

- `dbt_4ps_staging_generator`: Typer CLI that turns a bc2adls CDM manifest into
  dbt staging models (`generate`) and downloads the CDM metadata from a Unity
  Catalog volume (`download`).
- `dbt_4ps_staging_package`: 73 generated staging models for 4PS Construct,
  materialized as Databricks streaming tables, with column docs and
  primary-key uniqueness tests.
- A 3-table example CDM export in `_cdm/`.
