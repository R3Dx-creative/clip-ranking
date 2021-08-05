use crate::storage::{ Storage };

pub struct Clip {
    pub dir: String,
    pub name: String,
    pub like: usize,
    pub dst: String
}

impl Clip {
    pub fn with_like(dir: &str, name: &str, like: usize) -> Clip {
        Clip { dir: dir.to_string(), name: name.to_string(), like: like, dst: dir.to_string() }
    }

    pub fn new(dir: &str, name: &str) -> Clip {
        Clip::with_like(dir, name, 0)
    }

    pub fn src_path(&self) -> String {
        format!("{}/{}", self.dir, self.name)
    }

    pub fn dst_path(&self) -> String {
        format!("{}/{}", self.dir, self.dst)
    } 
}

pub fn clips<S>(storage: S, dir: &str) -> Result<Vec<Clip>, S::PatternError> where S: Storage {
    let pattern = dir.to_string() + "/*";
    let paths = storage.glob(pattern.as_str())?;

    let clips = paths
        .filter_map(|entry| { 
            let path = storage.to_path(entry)?;
            path.file_name()
                .and_then(|file_name| file_name.to_str())
                .map(|file_name| Clip::new(dir, file_name))
        })
        .collect();

    Ok(clips)
}