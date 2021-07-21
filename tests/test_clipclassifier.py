from clipranking.clipclassifier import ClipClassifier, Dest, anyway_true
from clipranking.clip import Clip
from datetime import date

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
        Dest(file, condition)
        for file, condition
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

    classifier = ClipClassifier(anyway_true, dests)
    clips = classifier.classify(clips)
    print(*clips, sep="\n")