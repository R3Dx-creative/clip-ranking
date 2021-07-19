from dataclasses import dataclass
from typing import Optional, Iterator
import os
import shutil
import glob

from config import Config

__BASE = Config.get("base")

@dataclass
class Clip:
    dir_name: str
    file_name: str
    kind: Optional[str] = None

    @property
    def src_path(self) -> str:
        return f"{self.dir_name}/{self.file_name}"

    @property
    def dest_path(self) -> str:
        return f"{self.kind}/{self.file_name}"

    # TODO async の使い方
    async def commit(self) -> None:
        if self.dir_name == self.kind:
            return
        
        if not os.path.exists(f"{__BASE}/{self.kind}"):
            os.makedirs(f"{__BASE}/{self.kind}")
        
        shutil.move(f"{__BASE}/{self.src_path}", f"{__BASE}/{self.dest_path}")

    def __str__(self):
        base = f"Clip(src: {self.src_path})"
        if self.dir_name != self.kind:
            base += f" -> {self.dest_path}"

        return base

    def __eq__(self, other: 'Clip') -> bool:
        return self.src_path == other.src_path \
               and self.dest_path == other.dest_path

    @staticmethod
    def clips(src_name) -> Iterator['Clip']:
        return (Clip(src_name, file_name)
                for file_name
                in glob.glob(f"{__BASE}/{src_name}"))