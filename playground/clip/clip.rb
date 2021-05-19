require 'yaml'
require 'fileutils'
require 'date'

require './config'

class Clip
  @@border = Config.get("border")
  @@ranking_n = Config.get("ranking_n")
  @@dest = Config.get("dest")
  @@ranked_folder = format(@@dest["ranked"], Date.today.strftime("%Y-%m-%d"))

  def initialize(dir, file, like)
    @dir = dir
    @file = file
    @like = like
    @kind = dir
  end

  def unranked?
    @like < @@border
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

  def rank!
    move!(@@ranked_folder)
  end

  def classify!
    dest =
      if unranked?
        @@dest["unranked"]
      else
        @@dest["revenging"]
      end
    move!(dest)
  end

  def self.clips(src, result)
    Dir.each_child(src).map { |file| Clip.new(src, file, result[file]) }
  end

  def self.classified(*clips)
    clips = clips.flatten
    unless clips
      return []
    end
    
    clips.sort_by!(&:sort_key)
    n = clips.size
    clips[0...@@ranking_n].each(&:rank!)

    if @@ranking_n < n
      clips[@@ranking_n...n].each(&:classify!)
    end
    
    clips
  end

  def sort_key
    [-@like, @file]
  end
  
  def to_s
    base = "Clip(src: #{src_path}, like: #{@like})"
    if @dir != @kind
      base << " -> #{dest_path}"
    end

    base
  end

  def src_path
    "#{@dir}/#{@file}"
  end

  def dest_path
    "#{@kind}/#{@file}"
  end
end
