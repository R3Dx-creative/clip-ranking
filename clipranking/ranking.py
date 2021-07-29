from typing import Callable, Iterator, Iterable, TypeVar

from clipranking.clip import Clip

SupportsLessThan = TypeVar("SupportsLessThan")

class Ranking:
    """
    クリップ仕分け機。仕分け元のディレクトリ名と仕分け先、仕分ける対象のフィルタ条件を保持する。
    """

    class NonExhaustivePatterns(Exception):
        pass

    def __init__(
        self,
        filter_key: Callable[[Clip], bool],
        sort_key: Callable[[Clip], SupportsLessThan],
        rules: dict[str, Callable[[int, Clip], bool]]
    ) -> None:
        self.filter_key = filter_key
        self.sort_key = sort_key
        self.rules = rules

    def ranked(self, clips: Iterable[Clip]) -> Iterator[Clip]:
        for i, clip in enumerate(sorted(filter(self.filter_key, clips), key=self.sort_key)):
            try:
                clip.dest = next(dir
                    for dir, condition
                    in self.rules.items()
                    if condition(i, clip)
                )
                yield clip
            except StopIteration:
                raise Ranking.NonExhaustivePatterns(clip)