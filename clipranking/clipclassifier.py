from dataclasses import dataclass
from typing import Callable, Iterator, Iterable

from clipranking.clip import Clip

def anyway_true(*args, **kwargs): return True

@dataclass
class Dest:
    """
    クリップの仕分け先。ディレクトリ名とディレクトリに保存するための条件を保持する。
    """

    name: str
    condition: Callable[[int, Clip], bool]


class ClipClassifier:
    """
    クリップ仕分け機。仕分け元のディレクトリ名と仕分け先、仕分ける対象のフィルタ条件を保持する。
    """

    def __init__(self, rule: Callable[[Clip], bool], dests: list[Dest]):
        self.rule = rule
        self.dests = dests

    def classify(self, clips: Iterable[Clip]) -> Iterator[Clip]:
        for i, clip in enumerate(filter(self.rule, clips)):
            clip.dest = next(dest.name
                for dest
                in self.dests
                if dest.condition(i, clip)
            )
            yield clip