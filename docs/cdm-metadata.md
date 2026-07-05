# CDM metadata

bc2adls writes [Common Data Model](https://learn.microsoft.com/en-us/common-data-model/) json files alongside the exported CSV deltas. They are the generator's only input — no connection to Business Central is needed.

## The files

- **`deltas.manifest.cdm.json`** — lists every exported entity with its partition pattern: where the CSVs live (`rootLocation`, `globPattern`) and how they're encoded (delimiter, encoding, escape, headers).
- **`<Table>-<id>.cdm.json`** — one per table, describing the columns: name, `dataFormat`, display name, max length, decimal scale, and which columns form the primary key.

They contain only schema metadata — no data and no connection details.

## The example export

The repo ships a trimmed example in `_cdm/` with three representative tables:

| File | Table |
|---|---|
| `PaymentTerms-3.cdm.json` | Payment Terms — a small lookup table |
| `Currency-4.cdm.json` | Currency |
| `Customer-18.cdm.json` | Customer — a wide table with strings, decimals, booleans, dates and GUIDs |

Try the generator against it:

```sh
cd dbt_4ps_staging_generator
uv run dbt-4ps-generator generate \
  --manifest ../_cdm/deltas.manifest.cdm.json \
  --output-directory /tmp/models
```

CI regenerates these entities on every push and diffs the output against the committed models, so the example doubles as an integration test.

## Getting your own

Use the [`download` command](generator.md#download) to pull the metadata for your full table set from the Unity Catalog volume bc2adls exports to, then [generate](generator.md#generate) the staging models for your tables.
