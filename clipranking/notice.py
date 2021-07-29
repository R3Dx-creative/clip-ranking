from typing import Protocol

class Notice(Protocol):
    def notify(self, content):
        ...
