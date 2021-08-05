use std::error::Error;
use glob;
use std::path::PathBuf;

pub trait Storage
where
    Self::PatternError: Error,
    Self::Paths: Iterator<Item=Self::Entry>
{
    type PatternError;
    type Paths;
    type Entry;
    fn glob(&self, pattern: &str) -> Result<Self::Paths, Self::PatternError>;
    fn to_path(&self, entry: Self::Entry) -> Option<PathBuf>;
}

pub struct LocalStorage {}
impl Storage for LocalStorage {
    type PatternError = glob::PatternError;
    type Paths = glob::Paths;
    type Entry = glob::GlobResult;
    fn glob(&self, pattern: &str) -> Result<glob::Paths, glob::PatternError> {
        glob::glob(pattern)
    }

    fn to_path(&self, entry: glob::GlobResult) -> Option<PathBuf> {
        match entry {
            Ok(e) => Some(e),
            _ => None
        }
    }
}

