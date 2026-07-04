# Contributing to dbt-4ps-staging

Thanks for your interest! Issues and pull requests are very welcome — especially
real-world bc2adls exports that the generator doesn't handle yet.

## Toolchain

This repo uses [`mise`](https://mise.jdx.dev) to pin tools,
[`uv`](https://docs.astral.sh/uv/) for envs/deps, and
[`ruff`](https://docs.astral.sh/ruff/) for lint + format.

```sh
mise install   # installs the pinned Python + uv (optional but recommended)
```

## Day-to-day

```sh
mise run test        # generator test suite (pytest)
mise run lint        # ruff check
mise run fmt         # ruff format
mise run check       # full pre-commit gate: lint + format check + tests
mise run generate    # regenerate models from the example manifest in _cdm/
mise run dbt:parse   # validate the dbt package parses
```

(Each task is a thin wrapper around `uv run ...` in the right directory — see
`mise.toml` if you prefer running them directly.)

All of these run in CI on every push/PR — please make sure they're green before
opening a PR. New behaviour should come with a test.

## Layout

- **`dbt_4ps_staging_generator/`** — the Python CLI. `cdm.py` parses the CDM
  json, `converters.py` maps CDM to SQL/dbt concepts, `dbt.py` writes the
  models and schema yaml.
- **`dbt_4ps_staging_package/`** — the generated dbt package. Don't hand-edit
  the models under `models/staging/4ps/` — change the generator and regenerate.
- **`_cdm/`** — a 3-table example export used by CI to verify the committed
  models stay in sync with the generator.

## Commits & PRs

- Small, focused PRs are easiest to review.
- Describe the *why*, not just the *what*.
- By contributing you agree your work is licensed under the project's
  [MIT License](LICENSE).
