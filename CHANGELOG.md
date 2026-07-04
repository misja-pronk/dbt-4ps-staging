# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- The generator is now an installable package, `dbt-4ps-generator`, published
  to PyPI on release (`uvx dbt-4ps-generator`), with a `--version` flag.
- Documentation site at <https://misja-pronk.github.io/dbt-4ps-staging/>.
- Version-driven release workflow: bumping the version in
  `dbt_4ps_staging_generator/pyproject.toml` and merging to `main` publishes to
  PyPI and creates the tag + GitHub release.
- `ty` type-checking; builder classes gained precise optional annotations and
  clear errors when required builder fields are missing.
- Tests now also run on Python 3.14 in CI.
- Ruff lint + format for the generator, with a CI job enforcing both.
- CI jobs verifying the committed models stay in sync with the generator, the
  wheel builds and installs, and the docs build strictly.
- `mise` tasks for the common workflows (`test`, `lint`, `fmt`, `typecheck`,
  `check`, `generate`, `dbt:parse`, `docs`, `build`).
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
