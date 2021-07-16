from clip_ranking.clip import Clip
from config import Config

FILE = [f"{i}.txt" for i in range(3)]

def init(i, like):
    return Clip("test_resources", f"{i}.txt", like)

def test_clip_attr():
    clip = init(0, 0)
    assert [FILE[0], 0] == [clip.file_name, clip.like]
