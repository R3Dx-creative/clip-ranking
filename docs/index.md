# 備忘録

## ファイル操作

## File - 組み込み
  * https://docs.ruby-lang.org/ja/latest/class/File.html

## FileUtils - `require 'fileutils'`が必要
  * https://docs.ruby-lang.org/ja/latest/class/FileUtils.html#M_COPY_STREAM

### 存在確認

```ruby
File.exist?(file_name)
```

### ファイル作成/ディレクトリ作成

```ruby
FileUtils.touch(file_name)
```

```ruby
FileUtils.mkdir(dir_name)
```

### ファイル削除/ディレクトリ削除

```ruby
FileUtils.remove(file_name)
# ディレクトリは扱えない
```

```ruby
FileUtils.remove_dir(dir_name)
```

### コピー

```ruby
FileUtils.copy(src, dest)
```

### ファイルの移動

```ruby
FileUtils.move(src, dest)
```

## TODO

* 複数ファイルをいっぺんに移動、コピー