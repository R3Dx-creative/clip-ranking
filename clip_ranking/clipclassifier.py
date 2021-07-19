from dataclasses import dataclass
from typing import Callable, Optional
from clip import Clip


@dataclass
class Dest:
    dest_name: str
    condition: Callable[[Clip], bool]

@dataclass
class ClipClassifier:
    src_name: str
    dests: list[Dest]
    rule: Callable[[Clip], bool]

    def classify(self, result: Optional[dict[str, int]]=None) -> list[Clip]:
        clips = sorted(
            Clip.clips(self.src_name),
            key=lambda clip: [-result[clip.file_name], clip.file_name]
        )

        for clip in filter(self.rule, clips):
            dest = next(dest for dest in self.dests if dest.condition(clip))
            clip.kind = dest.dest_name


        return clips