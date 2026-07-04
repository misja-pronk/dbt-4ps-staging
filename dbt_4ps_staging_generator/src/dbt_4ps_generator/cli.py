from importlib.metadata import version as pkg_version
from pathlib import Path

import typer

from dbt_4ps_generator.cdm import build_entities
from dbt_4ps_generator.converters import (
    argument_to_option,
    attribute_to_column,
    construct_path,
    to_snake_case_with_column_number_removed,
    trait_reference_to_format,
)
from dbt_4ps_generator.databricks_helper import download_cdm_files_from_databricks_volume
from dbt_4ps_generator.dbt import ModelBuilder, ModelsSchemaBuilder

app = typer.Typer(help="Generate dbt staging models from bc2adls CDM manifests.")


def _version_callback(value: bool):
    if value:
        typer.echo(pkg_version("dbt-4ps-generator"))
        raise typer.Exit()


@app.callback()
def main(
    version: bool = typer.Option(
        False, "--version", callback=_version_callback, is_eager=True, help="Show the version."
    ),
):
    pass


@app.command()
def generate(
    manifest: Path = typer.Option(
        ...,
        help="Path to the CDM manifest, e.g. _cdm/deltas.manifest.cdm.json. "
        "Entity .cdm.json files are resolved relative to this file.",
        exists=True,
        dir_okay=False,
    ),
    output_directory: Path = typer.Option(
        ...,
        help="Directory the .sql models and schema yaml are written to, "
        "e.g. dbt_4ps_staging_package/models/staging/4ps.",
        file_okay=False,
    ),
    model_prefix: str = typer.Option("stg_4ps__", help="Prefix for generated model names."),
    schema_name: str = typer.Option("models", help="Base name of the generated schema yaml."),
    schema_prefix: str = typer.Option("_4ps__", help="Prefix for the generated schema yaml."),
    file_metadata_column: bool = typer.Option(
        True, help="Add the _metadata column (source file info) to every model."
    ),
):
    """Generate one staging model per entity in the manifest, plus a schema yaml."""
    output_directory.mkdir(parents=True, exist_ok=True)

    entities = build_entities(manifest)
    configuration_builder = (
        ModelsSchemaBuilder()
        .name(name=schema_name, prefix=schema_prefix)
        .output_directory(output_directory)
    )

    for entity in entities:
        model_builder = (
            ModelBuilder()
            .name(name=entity.entity_name, prefix=model_prefix)
            .description(entity.description)
            .add_rename_function(to_snake_case_with_column_number_removed)
            .add_options([argument_to_option(a) for a in entity.arguments])
            .format(trait_reference_to_format(entity.trait_reference))
            .add_columns([attribute_to_column(a) for a in entity.attributes])
            .path(
                construct_path(root_location=entity.root_location, glob_pattern=entity.glob_pattern)
            )
            .add_file_metadata_column(file_metadata_column)
            .output_directory(output_directory)
            .build()
        )
        configuration_builder.add_model_builder(model_builder)

    configuration_builder.build()
    typer.echo(f"Generated {len(entities)} models in {output_directory}")


@app.command()
def download(
    volume_path: str = typer.Option(
        ...,
        help="Unity Catalog volume path holding the bc2adls export, "
        "e.g. /Volumes/<catalog>/<schema>/<volume>.",
    ),
    output_directory: Path = typer.Option(
        ..., help="Local directory to download the CDM json files into.", file_okay=False
    ),
):
    """Download CDM manifest and entity files from a Databricks volume.

    Authenticates via the Databricks SDK's default chain: set DATABRICKS_HOST and
    DATABRICKS_TOKEN, or use a configured profile (DATABRICKS_CONFIG_PROFILE).
    """
    download_cdm_files_from_databricks_volume(volume_path, output_directory)


if __name__ == "__main__":
    app()
