from dataclasses import dataclass
from typing import Callable, Iterator, Iterable

from clipranking.clip import Clip

@dataclass
class Rank:
    """
    クリップの仕分け先。ディレクトリ名とディレクトリに保存するための条件を保持する。
    """

    dir: str
    condition: Callable[[int, Clip], bool]


class Ranking:
    """
    クリップ仕分け機。仕分け元のディレクトリ名と仕分け先、仕分ける対象のフィルタ条件を保持する。
    """

    def __init__(self, rule: Callable[[Clip], bool], ranks: list[Rank]):
        self.rule = rule
        self.ranks = ranks

    def ranked(self, clips: Iterable[Clip]) -> Iterator[Clip]:
        for i, clip in enumerate(filter(self.rule, clips)):
            clip.dest = next(rank.dir
                for rank
                in self.ranks
                if rank.condition(i, clip)
            )
            yield clip