use glob;
use std::error::Error;
use std::fmt;
use std::path::PathBuf;

#[derive(Debug)]
pub struct PatternError {
    msg: String
}

impl fmt::Display for PatternError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Pattern error: {}", self.msg)
    }
}

impl Error for PatternError {}

pub trait Storage
where
    Self::Items: Iterator<Item=Self::Item>
{
    type Items;
    type Item;
    
    fn glob(&self, pattern: &str) -> Result<Self::Items, PatternError>;
    fn path(item: Self::Item) -> Option<PathBuf>;
}

pub struct LocalStorage {}

impl Storage for LocalStorage {
    type Items = glob::Paths;
    type Item = glob::GlobResult;

    fn glob(&self, pattern: &str) -> Result<glob::Paths, PatternError> {
        match glob::glob(pattern) {
            Err(glob::PatternError { pos, msg }) => {
                let msg = format!("pos: {}, msg: {}", pos, msg);
                Err(PatternError { msg: msg })
            },
            Ok(paths) => Ok(paths)
        }
    }

    fn path(item: glob::GlobResult) -> Option<PathBuf> {
        match item {
            Ok(path) => Some(path),
            Err(e) => panic!(e)
        }
    }
}

pub struct GoogleDrive {}

/// とりあえずLocalStorageと同じ内容
impl Storage for GoogleDrive {
    type Items = glob::Paths;
    type Item = glob::GlobResult;

    fn glob(&self, pattern: &str) -> Result<glob::Paths, PatternError> {
        match glob::glob(pattern) {
            Err(glob::PatternError { pos, msg }) => {
                let msg = format!("pos: {}, msg: {}", pos, msg);
                Err(PatternError { msg: msg })
            },
            Ok(paths) => Ok(paths)
        }
    }

    fn path(item: glob::GlobResult) -> Option<PathBuf> {
        match item {
            Ok(path) => Some(path),
            Err(e) => panic!(e)
        }
    }
}