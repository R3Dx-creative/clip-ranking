use std::io;
use std::fs;
use std::collections::HashMap;
use std::path::{ PathBuf };
use chrono::{ Utc };
use clip_ranking::storage;

fn main() -> io::Result<()> {
    let storage = storage::LocalStorage{};
    let items = storage::search(&storage, "tests/resources/*").unwrap();
    let result: HashMap<&str, i32> = [("0.txt", 4), ("1.txt", 8), ("2.txt", 2), ("3.txt", 5), ("4.txt", 1), ("5.txt", 1), ("6.txt", 8), ("7.txt", 4), ("8.txt", 8), ("9.txt", 6)].iter().cloned().collect();
    let packages = sorted_shipments(items, result);
    ship(packages)
}

type Shipment = (PathBuf, String);

fn ship(packages: Vec<Shipment>) -> io::Result<()> {
    packages.iter()
        .filter_map(|(path, dst)| {
            let file_name = path.file_name()?;
            let mut dst_dir = path.clone();
            dst_dir.pop();
            dst_dir.pop();
            dst_dir.push(dst);
            Some((path, dst_dir, file_name))
        })
        .map(|(path, mut dst_dir, file_name)| {
            if !dst_dir.exists() {
                fs::create_dir_all(&dst_dir)?;
            }
            dst_dir.push(file_name);
            println!("rename {:} to {:}", path.display(), dst_dir.display());
            fs::rename(path, dst_dir)
        })
        .collect()
}

fn sorted_shipments<I>(items: I, result: HashMap<&str, i32>) -> Vec<Shipment> where I: Iterator<Item=PathBuf> {
    let mut v = items
        .filter_map(|item| {
            let f = item.file_name()?.to_str()?;
            let like = result.get(f)?;
            Some((item, *like))
        })
        .collect::<Vec<(PathBuf, i32)>>();
    v.sort_by_key(|(_, like)| -like);

    let today = Utc::today().format("%F");
    v.into_iter()
        .enumerate()
        .filter_map(|(i, (item, like))| {
            if i < 3 {
                Some((item, today.to_string()))
            } else if like > 5 {
                Some((item, "Revenging".to_string()))
            } else {
                Some((item, "Unranked".to_string()))
            }
        })
        .collect()
}
