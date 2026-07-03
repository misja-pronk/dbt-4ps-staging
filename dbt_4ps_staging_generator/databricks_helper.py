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
        if not directory_entry.is_directory and directory_entry.name.endswith(".json"):
            print(directory_entry.path)
            resp = w.files.download(directory_entry.path)
            download_file = download_folder / Path(directory_entry.name)
            download_file.write_text(data=str(resp.contents.read(), encoding="utf-8"))
