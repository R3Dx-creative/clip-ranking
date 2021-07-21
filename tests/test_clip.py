from clipranking.clip import Clip
from config import Config

FILES = [f"{i}.txt" for i in range(3)]
BASE = Config.get("base")
DIR = "test_resources"

def init(i):
    return Clip(DIR, f"{i}.txt")

def test_clip_attr():
    clip = init(0)
    assert f"{DIR}/{FILES[0]}" == clip.src_path

def test_clips():
    clips = list(Clip.clips(DIR))
    assert len(clips) > 0
    assert [clip.src_path for clip in clips] == \
           [f"{DIR}/{file}" for file in FILES]
