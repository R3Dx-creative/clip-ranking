# clip-ranking

A system for game clips in closed friend community.

It aggregate reactions, notify, classification and concatenate game clips.

It is in develop yet.

# Features

## Classification rules

Users can set their rules for classification of clips (in main.py so far. It will be changed to original DSL).

```py
{
    f"Ranked.{date.today().isoformat()}": (lambda i, _: i < 3),
    "2.Revenging": (lambda _, clip: clip.like >= 5),
    "Unranked": anyway_true
}
```

This example means following.

1. Up to the third clips will be moved to "Ranked.[today]" folder.
2. Clips with 5 or more likes will be moved to "2.Revenging" folder.
3. The other clips will be moved to "Unranked" folder.

These rules are applied in order from the top.

## Aggregate

Users can extend to use their favorite way to aggregate reactions that are attached on clips by implementing `Aggregate` protocol.

## Storage

Users can extend to use their favorite storage service by implementing `Storage` protocol.

So far, this project will support local file system and Google Drive.

## Notice

Users can extend to use their favorite communication tool service by implementing `Notice` protocol.

So far, this project will support Discord.
