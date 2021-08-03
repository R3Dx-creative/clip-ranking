use std::fs;
use std::io;
use glob;

pub trait Storage
where
    Self::Files: Iterator
{
    type Files;
    fn glob(&self, dir: &str, pattern: &str) -> io::Result<Self::Files>;
}

struct LocalStorage {}
impl Storage for LocalStorage {
    type Files = ;
    fn glob(&self, dir: &str, pattern: &str) -> io::Result<Self::Files> {
        fs::read_dir(dir)
    }
}