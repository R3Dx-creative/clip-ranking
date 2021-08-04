use crate::storage::{ Storage };

pub struct Clip {
    dir: &'static str,
    name: &'static str,
    like: i32,
    dst: Option<String>
}

impl Clip {
    pub fn src_path(&self) -> String {
        format!("{}/{}", self.dir, self.name)
    }

    pub fn dst_path(&self) -> String {
        self.dst.as_ref()
        .map(|dst| {
            format!("{}/{}", self.dir, dst)
        })
        .unwrap_or(self.src_path())
    } 
}

pub fn clips<S>(storage: S, dir: &str) -> Result<S::Files, S::StorageError> where S: Storage {
    let pattern = dir.to_string() + "/*";
    storage.glob(pattern.as_str())
}