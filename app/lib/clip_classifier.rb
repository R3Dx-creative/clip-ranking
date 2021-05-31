require 'json'
require 'pp'
require 'date'

require_relative '../../config/config'

# クリップを仕分けるモジュール。
# +config/app_config.json+と+config/local_config.json+の設定値をもとに、+classify+メソッドでクリップを仕分ける。
# 仕様については{README}[./README_md.html]参照。
# ====設定値
# * local_config.json
#   * base - 仕分け作業のルートフォルダ
# * app_config.json
#   * border - ランキングに入るためのいいね数のボーダー
#   * ranking_n - ランキングに入れる数
#   * dest - 移動先フォルダ
#     * unranked - ランキング外を入れるフォルダ
#     * revenging - ランキング外ではあるが、いいね数がボーダーを超えた場合に入れるフォルダ
#     * ranked - ランキング内を入れるフォルダ。
#   * history_file - 直前の移動情報を保持するファイル名(json)
module ClipClassifier
  @@base = Config["base"]
  @@border = Config["border"]
  @@ranking_n = Config["ranking_n"]
  @@dest = Config["dest"]
  @@unranked_folder = @@dest["unranked"]
  @@revenging_folder = @@dest["revenging"]
  @@ranked_folder = format(@@dest["ranked"], Date.today.strftime("%Y-%m-%d"))
  @@history_path = "#{@@base}/#{Config["history_file"]}"

  # 直前の移動情報を保持するファイルのパス
  def history_path
    @@history_path
  end

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
  def classify(*clips)
    clips = clips.flatten
    unless clips
      return []
    end
    
    clips.sort_by! { |clip| [-clip.like, clip.file] }

    # クリップの仕分け
    clips.each_with_index do |clip, i|
      dest =
        if i < @@ranking_n
          @@ranked_folder
        elsif clip.like >= @@border
          @@revenging_folder
        else
          @@unranked_folder
        end
      clip.move!("#{@@base}/#{dest}")
    end
    
    clips
  end

  # 移動元と移動先の情報を保存する(直前の情報だけ)
  # [+clips+] クリップ集(Clip)
  def save_history(clips)
    history = clips
      .map { |clip| [clip.dest_path, clip.src_path] }
      .to_h

    File.open(@@history_path, "w") do |f|
      JSON.dump(history, f)
    end
  end


  module_function :classify, :save_history, :history_path
end