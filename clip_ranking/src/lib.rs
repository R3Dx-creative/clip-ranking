pub mod clip;
pub mod storage;
pub mod config;

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_config() {
        let config = &config::CONFIG;
        let local = &config.storage_type;

        println!("{:?}", config);
        assert_eq!("local", local);
    }

    #[test]
    fn test_clip_local_storage() {
        let storage = storage::LocalStorage{};
        let clips = clip::clips(storage, "tests/resources").unwrap();
        for (i, clip) in clips.iter().enumerate() {
            assert_eq!(
                format!("tests/resources/{}.txt", i),
                clip.src_path()
            );
        }
    }
}