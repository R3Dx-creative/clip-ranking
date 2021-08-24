
use std::collections::HashMap;
use std::path::{ PathBuf };
use chrono::{Utc};
use clip_ranking::storage;

fn main() {
    let storage = storage::LocalStorage{};
    let items = storage::search(&storage, "tests/resources/*").unwrap();
    let result: HashMap<&str, i32> = [("0.txt", 2), ("1.txt", 3), ("2.txt", 0)].iter().cloned().collect();
    let clips = classified(items, result);
    for (path, name) in clips {
        println!("{:}, {:}", path.display(), name);
    }
}

fn classified<I>(items: I, result: HashMap<&str, i32>) -> Vec<(PathBuf, String)> where I: Iterator<Item=PathBuf> {
    let mut v = items
        .filter_map(|clip| {
            let f = clip.file_name()?.to_str()?;
            let like = result.get(f)?;
            Some((clip, *like))
        })
        .collect::<Vec<(PathBuf, i32)>>();
    v.sort_by_key(|(_, like)| -like);
    v.into_iter()
        .enumerate()
        .filter_map(|(i, (clip, like))| {
            if i < 1 {
                Some((clip, format!("Ranked.{:}", Utc::today())))
            } else if like > 1 {
                Some((clip, "Revenging".to_string()))
            } else {
                Some((clip, "Unranked".to_string()))
            }
        })
        .collect()
}
