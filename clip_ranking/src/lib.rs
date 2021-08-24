pub mod storage;
pub mod config;

#[cfg(test)]
mod test {
    use std::path::Path;
    use super::*;

    #[test]
    fn test_config() {
        let config = &config::CONFIG;
        let shared = &config.shared_dir;
        assert_eq!("0.shared", shared);
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

    #[test]
    fn test_google_drive() {
        let storage = storage::GoogleDrive{};
        let clips = storage::search(&storage, "tests/resources/*").unwrap();
        for (i, clip) in clips.enumerate() {
            assert_eq!(
                Path::new(&format!("tests/resources/{}.txt", i)),
                clip
            );
        }
    }
}