from abc import ABC

class Notice(ABC):
    def notify(self, content):
        ...
