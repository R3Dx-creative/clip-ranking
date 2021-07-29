from typing import Protocol

class Aggregate(Protocol):
    def aggregate(self):
        ...