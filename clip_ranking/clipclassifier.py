from dataclasses import dataclass
from typing import Callable, Optional
from clip import Clip

@dataclass
class Dest:
    """
    クリップの仕分け先。ディレクトリ名とディレクトリに保存するための条件を保持する。
    """

    dest_name: str
    condition: Callable[[Clip], bool]

@dataclass
class ClipClassifier:
    """
    クリップ仕分け機。仕分け元のディレクトリ名と仕分け先、仕分ける対象のフィルタ条件を保持する。
    """

    src_name: str
    dests: list[Dest]
    rule: Callable[[Clip], bool]

    def classify(self, result: Optional[dict[str, int]]=None) -> list[Clip]:
        clips = sorted(
            filter(self.rule, Clip.clips(self.src_name)),
            key=lambda clip: [-result[clip.file_name], clip.file_name]
        )

        for clip in clips:
            dest = next(dest
                for dest
                in self.dests
                if dest.condition(clip)
            )
            clip.kind = dest.dest_name

        return clips