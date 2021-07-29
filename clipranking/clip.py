from dataclasses import dataclass
from typing import Optional, Iterator

from .storage import storage

@dataclass
class Clip:
    dir: str
    file: str
    like: int = 0
    dest: Optional[str] = None

    @property
    def src_path(self) -> str:
        return f"{self.dir}/{self.file}"

    @property
    def dest_path(self) -> str:
        if self.dest is None:
            return self.src_path

        return f"{self.dest}/{self.file}"

    # TODO async の使い方
    async def commit(self) -> None:
        if self.dir == self.dest:
            return
        
        if not storage.exists(self.dest):
            storage.makedirs(self.dest)
        
        storage.move(self.src_path, self.dest_path)

    def __str__(self):
        base = f"Clip(src: {self.src_path}, like: {self.like})"
        if self.dest is not None:
            base += f" -> {self.dest_path}"

        return base

    def __eq__(self, other: 'Clip') -> bool:
        return self.src_path == other.src_path \
               and self.dest_path == other.dest_path \
               and self.like == other.like

    @staticmethod
    def clips(dir, result: Optional[dict[str, int]]=None) -> Iterator['Clip']:
        if result is None:
            result = {}

        return (
            Clip(dir, file, result.get(file, 0))
            for file
            in storage.glob(dir, "*")
        )