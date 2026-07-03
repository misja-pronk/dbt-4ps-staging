from pydantic import BaseModel, Field
from typing import List, Optional

import json
from pathlib import Path


class Argument(BaseModel):
    name: str
    value: str


class PatternTraitReference(BaseModel):
    trait_reference: str = Field(alias="traitReference")
    arguments: List[Argument]


class DataPartitionPattern(BaseModel):
    name: str
    root_location: str = Field(alias="rootLocation")
    glob_pattern: str = Field(alias="globPattern")
    exhibits_traits: List[PatternTraitReference] = Field(alias="exhibitsTraits")


class ManifestEntity(BaseModel):
    type: str
    entity_name: str = Field(alias="entityName")
    entity_path: str = Field(alias="entityPath")
    data_partition_patterns: List[DataPartitionPattern] = Field(
        default=[], alias="dataPartitionPatterns"
    )

    def get_entity_name(self) -> str:
        return self.entity_name

    def get_entity_path(self) -> str:
        return self.entity_path

    def get_root_location(self) -> str:
        root_location = self.data_partition_patterns[0].root_location
        return root_location

    def get_glob_pattern(self) -> str:
        glob_pattern = self.data_partition_patterns[0].glob_pattern
        return glob_pattern

    def get_trait_reference(self) -> str:
        trait_reference = (
            self.data_partition_patterns[0].exhibits_traits[0].trait_reference
        )
        return trait_reference

    def get_arguments(self) -> list[dict]:
        arguments = self.data_partition_patterns[0].exhibits_traits[0].arguments
        return arguments


class Manifest(BaseModel):
    json_schema_semantic_version: str = Field(alias="jsonSchemaSemanticVersion")
    imports: List[str]
    manifest_name: str = Field(alias="manifestName")
    explanation: str
    entities: List[ManifestEntity] = Field(alias="entities")
    relationships: List[str]


class AppliedTrait(BaseModel):
    trait_reference: str = Field(alias="traitReference")
    arguments: List[dict]


class Attribute(BaseModel):
    name: str
    data_format: str = Field(alias="dataFormat")
    applied_traits: List[AppliedTrait] = Field(default=[], alias="appliedTraits")
    display_name: str = Field(alias="displayName")
    maximum_length: Optional[int] = Field(alias="maximumLength")
    is_primary_key: Optional[bool] = Field(default=False, alias="isPrimaryKey")


class Definition(BaseModel):
    entity_name: str = Field(alias="entityName")
    exhibits_traits: List[str] = Field(default=[], alias="exhibitsTraits")
    display_name: str = Field(alias="displayName")
    description: str
    has_attributes: List[Attribute] = Field(alias="hasAttributes")


class ModelEntity(BaseModel):
    json_schema_semantic_version: str = Field(alias="jsonSchemaSemanticVersion")
    imports: List[dict]
    definitions: List[Definition]

    def get_description(self) -> str:
        description = self.definitions[0].description
        return description

    def get_attributes(self) -> List[Attribute]:
        attributes = self.definitions[0].has_attributes
        return attributes
    
    def get_display_name(self) -> str:
        display_name = self.definitions[0].display_name
        return display_name


class Entity(BaseModel):
    root_location: str
    glob_pattern: str
    description: str
    attributes: List[Attribute]
    entity_name: str
    entity_path: str
    trait_reference: str
    arguments: List[Argument]
    display_name: str


def build_entities(manifest_path: Path) -> List[Entity]:
    entities = []
    manifest = Manifest(**json.loads(manifest_path.read_text()))
    for manifest_entity in manifest.entities:
        model_entity_path = manifest_path.parent / Path(
            manifest_entity.entity_path.split("/")[0]
        )
        model_entity = ModelEntity(**json.loads(model_entity_path.read_text()))

        entity = Entity(
            trait_reference=manifest_entity.get_trait_reference(),
            root_location=manifest_entity.get_root_location(),
            description=model_entity.get_description(),
            glob_pattern=manifest_entity.get_glob_pattern(),
            entity_name=manifest_entity.get_entity_name(),
            display_name=model_entity.get_display_name(),
            entity_path=manifest_entity.get_entity_path(),
            arguments=manifest_entity.get_arguments(),
            attributes=model_entity.get_attributes(),
        )

        entities.append(entity)

    return entities
