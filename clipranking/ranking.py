from typing import Callable, Iterator, Iterable

from clipranking.clip import Clip

class Ranking:
    """
    クリップ仕分け機。仕分け元のディレクトリ名と仕分け先、仕分ける対象のフィルタ条件を保持する。
    """

    def __init__(self, rule: Callable[[Clip], bool],
                 ranks: dict[str, Callable[[int, Clip], bool]]):
        self.rule = rule
        self.ranks = ranks

    def ranked(self, clips: Iterable[Clip]) -> Iterator[Clip]:
        for i, clip in enumerate(filter(self.rule, clips)):
            clip.dest = next(dir
                for dir, condition
                in self.ranks.items()
                if condition(i, clip)
            )
            yield clip