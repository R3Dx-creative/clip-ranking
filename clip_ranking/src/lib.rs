pub mod storage;
pub mod config;
pub mod shipment;

#[cfg(test)]
mod test {
    use std::collections::HashMap;
    use std::iter::FromIterator;
    use std::path::Path;
    use super::*;

    #[test]
    fn test_config() {
        let config = &config::CONFIG;
        let shared = &config.shared_dir;
        assert_eq!("0.shared", shared);
    }

    #[test]
    fn test_shipment() {
        let storage = storage::LocalStorage{};
        let items = Vec::from_iter(storage::search(&storage, "tests/resources/*").unwrap());
        let original_len = items.len();
        assert!(original_len > 0);

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

        let items = Vec::from_iter(storage::search(&storage, "tests/resources/*").unwrap());
        let a = Vec::from_iter(storage::search(&storage, "tests/A/*").unwrap());
        let b = Vec::from_iter(storage::search(&storage, "tests/B/*").unwrap());
        let c = Vec::from_iter(storage::search(&storage, "tests/C/*").unwrap());

        assert_eq!(items.len(), 0);
        assert_eq!(a.len(), 2);
        assert_eq!(b.len(), 1);
        assert_eq!(c.len(), 1);
        let back = shipment::sorted_shipments(a.into_iter().chain(b).chain(c), &weights,
            |(_, (item, &_))| {
                shipment::Shipment(item, "resources".to_string())
            }
        );
        shipment::ship(&storage, back).unwrap();
        let items = Vec::from_iter(storage::search(&storage, "tests/resources/*").unwrap());

        assert_eq!(original_len, items.len());
    }

    #[test]
    fn test_local_storage() {
        let storage = storage::LocalStorage{};
        let clips = storage::search(&storage, "tests/resources/*").unwrap();
        for (i, clip) in clips.enumerate() {
            assert_eq!(
                Path::new(&format!("tests/resources/{}.txt", i)),
                clip
            );
        }
    }

    // #[test]
    // fn test_google_drive() {
    //     let storage = storage::GoogleDrive{};
    //     let clips = storage::search(&storage, "tests/resources/*").unwrap();
    //     for (i, clip) in clips.enumerate() {
    //         assert_eq!(
    //             Path::new(&format!("tests/resources/{}.txt", i)),
    //             clip
    //         );
    //     }
    // }
}