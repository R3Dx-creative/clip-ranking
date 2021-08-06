use crate::storage::{ Storage, PatternError };

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

pub fn clips<S>(storage: &'static S, dir: &'static str, pattern: &str) -> Result<impl Iterator<Item=Clip>, PatternError> where S: Storage {
    let pattern = dir.to_string() + "/" + pattern;
    let items = storage.glob(pattern.as_str())?;

    let clips = items
        .filter_map(move |item| { 
            let path = storage.path(item)?;
            path.file_name()
                .and_then(|name| name.to_str())
                .map(|name| Clip::new(&dir, name))
        });

    Ok(clips)
}