use std::fs;
use std::io;
use std::error::Error;
use glob;

pub trait Storage
where
    Self::Files: Iterator,
    Self::StorageError: Error
{
    type Files;
    type StorageError;
    fn glob(&self, pattern: &str) -> Result<Self::Files, Self::StorageError>;
}

pub struct LocalStorage {}
impl Storage for LocalStorage {
    type Files = glob::Paths;
    type StorageError = glob::PatternError;
    fn glob(&self, pattern: &str) -> Result<Self::Files, glob::PatternError> {
        glob::glob(pattern)
    }
}
