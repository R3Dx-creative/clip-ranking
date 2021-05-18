require 'fileutils'
require 'test/unit'

A = "./A/"
B = "./B/"
C = "./C/"
D = "./D/"

FILE_NAME = "file.txt"

class FileProcessingTest < Test::Unit::TestCase
  def make_if_not_exist(name, mode)
    if !File.exist?(name)
      if mode == :dir
        FileUtils.mkdir(name)
      elsif 
        FileUtils.touch(name)
      end
    end
  end

  def remove_if_exist(name)
    if File.exist?(name)
      if File.directory?(name)
        FileUtils.remove_dir(name)
      elsif 
        FileUtils.remove(name)
      end
    end
  end

  def test_make_and_remove
    new_dir = D

    make_if_not_exist(new_dir, :dir)
    assert File.exist?(new_dir)

    remove_if_exist(new_dir)
    assert !File.exist?(new_dir)

    
    new_file = A + FILE_NAME

    remove_if_exist(new_file)
    assert !File.exist?(new_file)

    make_if_not_exist(new_file, :file)
    assert File.exist?(new_file)
  end

  
  def test_copy_file 
    src = A + FILE_NAME
    dest = B + FILE_NAME
    
    make_if_not_exist(src, :file)
    FileUtils.copy(src, dest)
    assert File.exist?(dest)
  end

  def test_move_file
    src = A + FILE_NAME
    dest = B + FILE_NAME

    make_if_not_exist(src, :file)
    remove_if_exist(dest)

    FileUtils.move(src, dest)
    assert !File.exist?(src)
    assert File.exist?(dest)
  end
end