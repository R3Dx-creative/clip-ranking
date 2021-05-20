require 'fileutils'

class Clip
  attr_reader :file, :like

  def initialize(dir, file, like)
    @dir = dir
    @file = file
    @like = like
    @kind = dir
  end

  # クリップ移動メソッド(安全のため、移動先を保持するだけ)
  # commitメソッドによってファイルの移動を行う。
  # 第二引数に:forceを指定すると、ファイルの移動を行う。
  def move!(dest, option=nil)
    @kind = dest

    if option == :force
      commit
    end
  end

  def commit
    if @dir == @kind
      return
    end
    
    unless Dir.exist?(@kind)
      FileUtils.mkdir_p(@kind)
    end

    FileUtils.move("#{@dir}/#{@file}", @kind)
  end

  def src_path
    "#{@dir}/#{@file}"
  end

  def dest_path
    "#{@kind}/#{@file}"
  end

end

# 文字列表現
class Clip
  def to_s
    base = "Clip(src: #{src_path}, like: #{@like})"
    if @dir != @kind
      base << " -> #{dest_path}"
    end

    base
  end
end

# クラスメソッド
class Clip
  def self.clips(src, result)
    Dir.each_child(src).map { |file| Clip.new(src, file, result[file]) }
  end
end
