from clipranking.ranking import Ranking, Rank
from clipranking.clip import Clip
from datetime import date

def anyway_true(*args, **kwargs): return True

def test_clipclassify():
    result = {
        "0.txt" : 0,
        "1.txt" : 5,
        "2.txt" : 5,
        "3.txt" : 6,
        "4.txt" : 7,
        "5.txt" : 5,
        "6.txt" : 1
    }

    dests = [
        Rank(dir, condition)
        for dir, condition
        in {
            f"Ranked.{date.today().isoformat()}": (lambda i, _: i < 3),
            "2.Revenging": (lambda _, clip: result[clip.file] >= 5),
            "Unranked": anyway_true
        }.items()
    ]

    clips = sorted(
        Clip.clips(f"1.Queue", result),
        key=lambda clip: [-result[clip.file], clip.file]
    )

    assert len(clips) > 0

    ranking = Ranking(anyway_true, dests)
    clips = ranking.ranked(clips)
    print(*clips, sep="\n")