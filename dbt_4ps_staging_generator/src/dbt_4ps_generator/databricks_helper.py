from pathlib import Path

from databricks.sdk import WorkspaceClient
from rich import print


def download_cdm_files_from_databricks_volume(volume_path: str, download_folder: Path) -> None:
    """Download all .json files from a Unity Catalog volume to a local folder.

    Uses the Databricks SDK default authentication chain (DATABRICKS_HOST /
    DATABRICKS_TOKEN environment variables, or a profile from ~/.databrickscfg).
    """
    w = WorkspaceClient()
    download_folder.mkdir(parents=True, exist_ok=True)

    for directory_entry in w.files.list_directory_contents(volume_path):
        name, path = directory_entry.name, directory_entry.path
        if directory_entry.is_directory or not name or not path or not name.endswith(".json"):
            continue
        print(path)
        resp = w.files.download(path)
        if resp.contents is None:
            raise RuntimeError(f"Empty response downloading {path}")
        download_file = download_folder / Path(name)
        download_file.write_text(data=str(resp.contents.read(), encoding="utf-8"))
