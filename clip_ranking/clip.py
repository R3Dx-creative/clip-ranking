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
    like: int
    kind: Optional[str] = None

    @property
    def src_path(self) -> str:
        return f"{self.dir_name}/{self.file_name}"

    @property
    def dest_path(self) -> str:
        return f"{self.kind}/{self.file_name}"

    def move(self, dest: str) -> None:
        self.kind = dest

    # TODO async の使い方
    async def commit(self) -> None:
        if self.dir_name == self.kind:
            return
        
        if not os.path.exists(f"{__BASE}/{self.kind}"):
            os.makedirs(f"{__BASE}/{self.kind}")
        
        shutil.move(f"{__BASE}/{self.src_path}", f"{__BASE}/{self.dest_path}")

    def __str__(self):
        base = f"Clip(src: {self.src_path}, like: {self.like}"
        if self.dir_name != self.kind:
            base += f" -> {self.dest_path}"

        return base

    def __eq__(self, other: 'Clip') -> bool:
        return self.src_path == other.src_path \
               and self.dest_path == other.dest_path \
               and self.like == other.like

    # TODO Python 3.9 の型ヒント
    @staticmethod
    def clips(src, result: Optional[dict]=None) -> Iterator['Clip']:
        if result is None:
            result = {}

        return (Clip(src, file_name, result.get(file_name, 0))
                for file_name
                in glob.glob(f"{__BASE}/{src}"))