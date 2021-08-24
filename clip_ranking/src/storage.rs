use glob;
use std::error::Error;
use std::fmt;
use std::path::PathBuf;

// ===--- trait ---===
pub trait Storage
where
    Self::Item: ToPathBuf,
    Self::Items: Iterator<Item=Self::Item>
{
    type Items;
    type Item;
    
    fn glob(&self, pattern: &str) -> Result<Self::Items, PatternError>;
}

pub trait ToPathBuf {
    fn to_path(self) -> Result<PathBuf, ToPathBufError>;
}

pub fn search<S>(storage: &S, pattern: &str) -> Result<impl Iterator<Item=PathBuf>, PatternError> where S: Storage {
    let items = storage.glob(pattern)?;
    let paths = items.flat_map(|item| item.to_path());
    Ok(paths)
}

// ===--- error ---===
#[derive(Debug)]
pub struct PatternError {
    msg: &'static str 
}

impl fmt::Display for PatternError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "pattern error: {}", self.msg)
    }
}

impl Error for PatternError {}

#[derive(Debug)]
pub struct ToPathBufError {}

impl fmt::Display for ToPathBufError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "path error")
    }
}

impl Error for ToPathBufError {}

// ===--- implementation ---===
impl ToPathBuf for glob::GlobResult {
    fn to_path(self) -> Result<PathBuf, ToPathBufError> {
        match self {
            Ok(path) => Ok(path),
            Err(_) => Err(ToPathBufError {})
        }
    }
}

pub struct LocalStorage {}

impl Storage for LocalStorage {
    type Items = glob::Paths;
    type Item = glob::GlobResult;

    fn glob(&self, pattern: &str) -> Result<glob::Paths, PatternError> {
        match glob::glob(pattern) {
            Err(glob::PatternError { pos: _, msg }) => {
                Err(PatternError { msg: msg })
            },
            Ok(paths) => Ok(paths)
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
            Err(glob::PatternError { pos: _, msg }) => {
                Err(PatternError { msg: msg })
            },
            Ok(paths) => Ok(paths)
        }
    }
}
