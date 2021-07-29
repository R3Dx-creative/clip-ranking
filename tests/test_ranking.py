from clipranking.ranking import Ranking
from clipranking.clip import Clip
from datetime import date

def anyway_true(*args, **kwargs): return True

def test_ranking():
    result = {
        "0.txt" : 0,
        "1.txt" : 5,
        "2.txt" : 5,
        "3.txt" : 6,
        "4.txt" : 7,
        "5.txt" : 5,
        "6.txt" : 1
    }

    rules = {
        f"Ranked.{date.today().isoformat()}": (lambda i, _: i < 3),
        "2.Revenging": (lambda _, clip: clip.like >= 5),
        "Unranked": anyway_true
    }

    clips = list(Clip.clips(f"1.Queue", result))

    assert len(clips) > 0

    ranking = Ranking(anyway_true, lambda clip: [-clip.like, clip.file], rules)

    actual = list(ranking.ranked(clips))

    expected = [
        Clip("1.Queue", "4.txt", 7, f"Ranked.{date.today().isoformat()}"),
        Clip("1.Queue", "3.txt", 6, f"Ranked.{date.today().isoformat()}"),
        Clip("1.Queue", "1.txt", 5, f"Ranked.{date.today().isoformat()}"),
        Clip("1.Queue", "2.txt", 5, "2.Revenging"),
        Clip("1.Queue", "5.txt", 5, "2.Revenging"),
        Clip("1.Queue", "6.txt", 1, "Unranked"),
        Clip("1.Queue", "0.txt", 0, "Unranked")
    ]

    assert expected == actual
