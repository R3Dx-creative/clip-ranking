# clip-ranking

A system for interesting files for closed friend community.

For example, it notify game clips to Discord and aggregate reactions on them, and sort them.

Also, users can implement particular ways to do them.

This system is in develop yet.

# Features

## Storage

Users can extend to use their particular storage service by implementing `Storage` protocol.

So far, this project will support local file system and Google Drive.

## Rules for Sorting

Users can set their rules for sorting of items according weight. (info to sort item is called "Shipment")

```rust
let weights: HashMap<&str, i32> = [("0.txt", 4), ("1.txt", 6), ("2.txt", 3), ("3.txt", 5)].iter().cloned().collect();

let shipments = shipment::sorted_shipments(items.into_iter(), &weights,
    |(i, (item, &weight))| {
        if i < 2 {
            shipment::Shipment(item, "A".to_string())
        } else if weight > 3 {
            shipment::Shipment(item, "B".to_string())
        } else {
            shipment::Shipment(item, "C".to_string())
        }
    }
);

shipment::ship(&storage, shipments).unwrap();
```

This example means following.

1. Up to the second items will be moved to "A" folder.
2. items with 5 or more weights will be moved to "B" folder.
3. The other items will be moved to "C" folder.

These rules are applied in order from the top.

## Notice

Users can extend to use their particular communication service by implementing `Notice` protocol.

So far, this project will support Discord.

## Aggregate

Users can extend to use their particular way to aggregate reactions that are attached on items by implementing `Aggregate` protocol.
