from typing import Iterator, Protocol
from pathlib import Path
import os
import shutil
from config import Config

_BASE = Config.get("base")

class Storage(Protocol):
    def exists(self, path: str) -> bool:
        ...
    
    def makedirs(self, name: str) -> None: 
        ...

    def move(self, src: str, dst: str) -> None:
        ...

    def glob(self, path: str, pattern: str) -> Iterator[str]:
        ...

class LocalStorage:
    def exists(self, path: str) -> bool:
        return os.path.exists(f"{_BASE}/{path}")

    def makedirs(self, name: str) -> None:
        os.makedirs(f"{_BASE}/{name}")

    def move(self, src: str, dst: str) -> None:
        shutil.move(f"{_BASE}/{src}", f"{_BASE}/{dst}")

    def glob(self, path: str, pattern: str) -> Iterator[str]:
        return (
            file.name
            for file 
            in Path(f"{_BASE}/{path}").glob(pattern)
        )


storage_types: dict[str, Storage] = {
    "local": LocalStorage()
}

storage = storage_types[Config.get("storage_type")]