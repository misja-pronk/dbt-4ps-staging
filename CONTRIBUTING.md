# Contributing to dbt-4ps-staging

Thanks for your interest! Issues and pull requests are very welcome — especially
real-world bc2adls exports that the generator doesn't handle yet.

## Toolchain

This repo uses [`mise`](https://mise.jdx.dev) to pin tools and the all-Astral
stack — [`uv`](https://docs.astral.sh/uv/) (env / deps / run),
[`ruff`](https://docs.astral.sh/ruff/) (lint + format), and
[`ty`](https://docs.astral.sh/ty/) (type check).

```sh
mise install   # installs the pinned Python + uv (optional but recommended)
```

## Day-to-day

```sh
mise run test        # generator test suite (pytest)
mise run lint        # ruff check
mise run fmt         # ruff format
mise run typecheck   # ty check
mise run check       # full pre-commit gate: lint + format check + types + tests
mise run generate    # regenerate models from the example manifest in _cdm/
mise run dbt:parse   # validate the dbt package parses
mise run docs        # preview the docs site at localhost:8000
mise run build       # build the generator wheel + sdist
```

(Each task is a thin wrapper around `uv run ...` in the right directory — see
`mise.toml` if you prefer running them directly.)

All of these run in CI on every push/PR — please make sure they're green before
opening a PR. New behaviour should come with a test.

## Layout

- **`dbt_4ps_staging_generator/`** — the Python CLI, as a `src/dbt_4ps_generator`
  package. `cdm.py` parses the CDM json, `converters.py` maps CDM to SQL/dbt
  concepts, `dbt.py` writes the models and schema yaml, `cli.py` is the Typer
  entry point.
- **`dbt_4ps_staging_package/`** — the generated dbt package. Don't hand-edit
  the models under `models/staging/4ps/` — change the generator and regenerate.
- **`_cdm/`** — a 3-table example export used by CI to verify the committed
  models stay in sync with the generator.

## Commits & PRs

- Small, focused PRs are easiest to review.
- Describe the *why*, not just the *what*.
- By contributing you agree your work is licensed under the project's
  [MIT License](LICENSE).

## Releasing

Releases are **version-driven**: the `version` in
`dbt_4ps_staging_generator/pyproject.toml` is the single source of truth, and
merging a bump to `main` ships it. No manual tagging.

1. On a branch, bump the version:

   ```sh
   cd dbt_4ps_staging_generator
   uv version --bump patch   # or: minor / major — edits pyproject.toml + uv.lock
   ```

2. In `CHANGELOG.md`, rename the `## [Unreleased]` heading to `## [X.Y.Z]` (the
   new version) and start a fresh, empty `## [Unreleased]` above it. Those notes
   become the GitHub release body.
3. Open a PR. When it merges to `main`, the [`release`](.github/workflows/release.yml)
   workflow:
   - builds the wheel + sdist and publishes them to **PyPI** as
     [`dbt-4ps-generator`](https://pypi.org/project/dbt-4ps-generator/) (via
     Trusted Publishing — no API token), and
   - creates the **`vX.Y.Z`** git tag and a **GitHub release** with the changelog
     notes.

A merge that doesn't change the version is a no-op, and a version that's already
tagged or already on PyPI is skipped — so the workflow is safe to re-run.

> **One-time setup.** Releasing uses [PyPI Trusted Publishing](https://docs.pypi.org/trusted-publishers/)
> instead of a token. Add a publisher at
> <https://pypi.org/manage/account/publishing/> for repository
> `misja-pronk/dbt-4ps-staging`, workflow `release.yml`, and environment `pypi`.
