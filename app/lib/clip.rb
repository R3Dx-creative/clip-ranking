require 'fileutils'

require_relative '../../config/config'

# ファイルといいね数を表すクラス。
# 主な機能はファイルの移動(+move!+メソッドと+commit+メソッド)。
# ==== 例
#   # clipsフォルダ、awesome_clip.mp4ファイル、いいね数10 を指定。
#   clip = Clip.new("clips", "awesome_clip.mp4", 10)
#   # awesomeフォルダに移動(この時点では移動先を保持するのみ)
#   clip.move!("awesome")
#   # 実際の移動(ファイル移動のエラーなどを事前にチェックするため一発で移動しないようにしている)
#   clip.commit()
class Clip
  BASE = Config["base"].freeze

  # ファイル名
  attr_reader :file

  # いいね数
  attr_reader :like

  # [+dir+] 格納されているフォルダ
  # [+file+] クリップのファイル名
  # [+like+] いいね数
  def initialize(dir, file, like)
    @dir = dir
    @file = file
    @like = like
    @kind = dir
  end

  # クリップ移動メソッド(移動先を保持するだけ)。 
  # +commit+メソッドによって実際にファイルの移動を行う。
  # 第二引数に+:force+を指定すると、ファイルの移動を行う。
  # [+dest+] 移動先フォルダ
  # [+option+(任意)] +:force+を指定すると、即座に+commit+メソッドを呼ぶ
  def move!(dest, option=nil)
    @kind = dest

    if option == :force
      commit
    end
  end

  # 保持した移動先に実際に移動する。
  # 格納先のフォルダが存在しなければ作成する。
  def commit
    if @dir == @kind
      return
    end
    
    unless Dir.exist?("#{BASE}/#{@kind}")
      FileUtils.mkdir_p("#{BASE}/#{@kind}")
    end

    FileUtils.move("#{BASE}/#{src_path}", "#{BASE}/#{dest_path}")
  end

  # クリップのパス
  def src_path
    "#{@dir}/#{@file}"
  end

  # クリップの移動先のパス
  def dest_path
    "#{@kind}/#{@file}"
  end

end

class Clip
  def to_s
    base = "Clip(src: #{src_path}, like: #{@like})"
    if @dir != @kind
      base << " -> #{dest_path}"
    end

    base
  end
end

class Clip
  # [+other+] Clip オブジェクト
  # 戻り値 :: src_path, dest_path, +like+ が等しいとき _true_, それ以外 _false_
  def ==(other)
    src_path == other.src_path &&
    dest_path == other.dest_path &&
    like == other.like  
  end
end

class Clip
  # フォルダ名と+result+(ファイル名といいね数の対応)をもとに、
  # フォルダ配下のファイルから Clip オブジェクトの配列を作成するメソッド。
  # [+src+] 格納されているフォルダ名
  # [+result+] ファイル名がキー、いいね数が値の Hash
  # 戻り値 :: Clip の Array
  # [例]
  # =====
  #    result = {"clip1.mp4" => 1, "clip2.map" => 10}
  #    clips = Clip.clips("clips", result)
  #    # [Clip(src: clips/clip1.mp4, like: 1), Clip(src: clips/clip2.mp4, like: 10)]
  def self.clips(src, result={})
    Dir.each_child("#{BASE}/#{src}").map { |file| Clip.new(src, file, result[file]) }
  end
end
