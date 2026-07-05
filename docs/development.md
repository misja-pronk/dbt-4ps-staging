# Development

Issues and pull requests are very welcome — especially real-world bc2adls exports that the generator doesn't handle yet. The full guide lives in [CONTRIBUTING.md](https://github.com/misja-pronk/dbt-4ps-staging/blob/main/CONTRIBUTING.md); the short version:

## Toolchain

[`mise`](https://mise.jdx.dev) pins the tools, [`uv`](https://docs.astral.sh/uv/) manages envs/deps, [`ruff`](https://docs.astral.sh/ruff/) lints and formats, [`ty`](https://docs.astral.sh/ty/) type-checks.

```sh
mise install   # installs the pinned Python + uv
```

## Day-to-day

```sh
mise run test        # generator test suite (pytest)
mise run lint        # ruff check
mise run fmt         # ruff format
mise run typecheck   # ty check
mise run check       # full pre-commit gate
mise run generate    # regenerate the sample models from the example manifest
mise run dbt:parse   # validate the example dbt project parses
mise run docs        # preview this site at localhost:8000
```

All of these run in CI on every push/PR.

## Layout

- **`dbt_4ps_staging_generator/`** — the CLI, as a `src/dbt_4ps_generator` package: `cdm.py` parses the CDM json, `converters.py` maps CDM to SQL/dbt concepts, `dbt.py` writes the models and schema yaml, `cli.py` is the Typer entry point.
- **`example_dbt_project/`** — a minimal example dbt project with 3 sample generated models. The models are never hand-edited; CI regenerates them from `_cdm/` and diffs.
- **`_cdm/`** — the 3-table example export used by CI as an integration fixture.

## Releasing

Releases are version-driven: bump the version in `dbt_4ps_staging_generator/pyproject.toml` (`uv version --bump patch|minor|major`), move the CHANGELOG notes under the new heading, and merge to `main`. The release workflow publishes to PyPI via Trusted Publishing and creates the `vX.Y.Z` tag + GitHub release automatically.
