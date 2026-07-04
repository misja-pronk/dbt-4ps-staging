import json

import yaml
from typer.testing import CliRunner

from main import app

MANIFEST = {
    "jsonSchemaSemanticVersion": "1.0.0",
    "imports": [],
    "manifestName": "deltas",
    "explanation": "test manifest",
    "relationships": [],
    "entities": [
        {
            "type": "LocalEntity",
            "entityName": "PaymentTerms-3",
            "entityPath": "PaymentTerms-3.cdm.json/PaymentTerms-3",
            "dataPartitionPatterns": [
                {
                    "name": "PaymentTerms-3",
                    "rootLocation": "deltas/PaymentTerms-3",
                    "globPattern": "/*.csv",
                    "exhibitsTraits": [
                        {
                            "traitReference": "is.partition.format.CSV",
                            "arguments": [
                                {"name": "columnHeaders", "value": "true"},
                                {"name": "delimiter", "value": ","},
                                {"name": "escape", "value": "\\"},
                                {"name": "encoding", "value": "utf-8"},
                                {"name": "quote", "value": '"'},
                            ],
                        }
                    ],
                }
            ],
        }
    ],
}

ENTITY = {
    "jsonSchemaSemanticVersion": "1.0.0",
    "imports": [],
    "definitions": [
        {
            "entityName": "PaymentTerms-3",
            "displayName": "Payment Terms",
            "description": "Represents the table Payment Terms",
            "hasAttributes": [
                {
                    "name": "Code-1",
                    "dataFormat": "String",
                    "displayName": "Code",
                    "maximumLength": 10,
                    "isPrimaryKey": True,
                },
                {
                    "name": "Discount-4",
                    "dataFormat": "Decimal",
                    "displayName": "Discount %",
                    "maximumLength": 12,
                    "appliedTraits": [
                        {
                            "traitReference": "is.dataFormat.numeric.shaped",
                            "arguments": [{"name": "scale", "value": 5}],
                        }
                    ],
                },
            ],
        }
    ],
}


def write_fixture(directory):
    manifest_path = directory / "deltas.manifest.cdm.json"
    manifest_path.write_text(json.dumps(MANIFEST))
    (directory / "PaymentTerms-3.cdm.json").write_text(json.dumps(ENTITY))
    return manifest_path


def test_generate_end_to_end(tmp_path):
    manifest_path = write_fixture(tmp_path)
    output_directory = tmp_path / "models"

    runner = CliRunner()
    result = runner.invoke(
        app,
        [
            "generate",
            "--manifest",
            str(manifest_path),
            "--output-directory",
            str(output_directory),
        ],
    )
    assert result.exit_code == 0, result.output

    sql = (output_directory / "stg_4ps__payment_terms.sql").read_text()
    assert "`Code-1` as `code`" in sql
    assert "`Discount-4` as `discount`" in sql
    assert "`Code-1` string, `Discount-4` decimal(12,5)" in sql
    assert "escape => '\\\\'" in sql
    assert "_metadata" in sql

    schema = yaml.safe_load((output_directory / "_4ps__models.yaml").read_text())
    model = schema["models"][0]
    assert model["name"] == "stg_4ps__payment_terms"
    assert model["description"] == "Represents the table Payment Terms"
    assert model["data_tests"] == [
        {"dbt_utils.unique_combination_of_columns": {"combination_of_columns": ["code"]}}
    ]
    assert model["columns"][0] == {"name": "code", "description": "Code"}


def test_generate_without_file_metadata_column(tmp_path):
    manifest_path = write_fixture(tmp_path)
    output_directory = tmp_path / "models"

    runner = CliRunner()
    result = runner.invoke(
        app,
        [
            "generate",
            "--manifest",
            str(manifest_path),
            "--output-directory",
            str(output_directory),
            "--no-file-metadata-column",
        ],
    )
    assert result.exit_code == 0, result.output
    sql = (output_directory / "stg_4ps__payment_terms.sql").read_text()
    assert "_metadata" not in sql
