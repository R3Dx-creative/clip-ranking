require 'json'
require 'pp'
require 'date'

require_relative '../../config/config'

# クリップを仕分けるモジュール。
# +config/app_config.json+と+config/local_config.json+の設定値をもとに、+classify+メソッドでクリップを仕分ける。
# 仕様については{README}[./README_md.html]参照。
module ClipClassifier
  BORDER = Config["border"].freeze
  RANKING_N = Config["ranking_n"].freeze
  SRC = Config["src"].freeze
  UNRANKED_FOLDER = SRC["unranked"].freeze
  REVENGING_FOLDER = SRC["revenging"].freeze
  RANKED_FOLDER = SRC["ranked"].freeze

  # クリップを仕分けるメソッド。設定値と Clip オブジェクトの+like+をもとに+move!+まで行う
  # [+clips+] クリップ集(Clip)
  # ====例
  #   src = "clips"
  #   result = {
  #    "0.txt" => 0,
  #    "1.txt" => 5,
  #    "2.txt" => 5,
  #    "3.txt" => 6,
  #    "4.txt" => 7,
  #    "5.txt" => 5,
  #    "6.txt" => 1
  #   }
  #   clips = Clip.clips(src, result)
  #   sorted = ClipClassifier.classify(clips)
  #   sorted.each(&:commit)
  def self.classify(*clips)
    clips = clips.flatten
    unless clips
      return []
    end
    
    clips.sort_by! { |clip| [-clip.like, clip.file] }

    # クリップの仕分け
    clips.each_with_index do |clip, i|
      dest =
        if i < RANKING_N
          format(RANKED_FOLDER, Date.today.strftime("%Y-%m-%d"))
        elsif clip.like >= BORDER
          REVENGING_FOLDER
        else
          UNRANKED_FOLDER
        end
      clip.move!("#{dest}")
    end
    
    clips
  end
end