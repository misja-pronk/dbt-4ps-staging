# Example CDM export

A trimmed-down example of the [CDM](https://learn.microsoft.com/en-us/common-data-model/) metadata that [bc2adls](https://github.com/Bertverbeek4PS/bc2adls) writes next to the CSV deltas when exporting Business Central tables. It contains three representative tables so you can try the generator without a Business Central environment:

| File | Table |
|---|---|
| `deltas.manifest.cdm.json` | The manifest listing every exported entity and its partition pattern |
| `PaymentTerms-3.cdm.json` | Payment Terms — a small lookup table |
| `Currency-4.cdm.json` | Currency |
| `Customer-18.cdm.json` | Customer — a wide table with strings, decimals, booleans, dates and GUIDs |

Try it:

```bash
cd ../dbt_4ps_staging_generator
uv run dbt-4ps-generator generate \
  --manifest ../_cdm/deltas.manifest.cdm.json \
  --output-directory /tmp/models
```

## Getting the metadata for your own environment

bc2adls uploads these json files to the same location as the data. If you export to a Unity Catalog volume, download them with the bundled command (authenticates via `DATABRICKS_HOST`/`DATABRICKS_TOKEN` or a `~/.databrickscfg` profile):

```bash
cd ../dbt_4ps_staging_generator
uv run dbt-4ps-generator download \
  --volume-path /Volumes/<catalog>/<schema>/<volume> \
  --output-directory ../_cdm
```

Then point `generate` at the downloaded `deltas.manifest.cdm.json` to build staging models for your full table set — write them into a copy of [`../example_dbt_project`](../example_dbt_project/).
