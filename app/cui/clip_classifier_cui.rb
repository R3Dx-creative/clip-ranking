require 'json'
require 'pp'
require 'date'

require_relative '../lib/clip'
require_relative '../lib/clip_classifier'

# CUIによるクリップの仕分け
# ==== 例
#   result = {
#     "0.txt" => 0,
#     "1.txt" => 5,
#     "2.txt" => 5,
#     "3.txt" => 6,
#     "4.txt" => 7,
#     "5.txt" => 5,
#     "6.txt" => 1
#   }
#   ClipClassifierCUI.run("#{Config["base"]}/1.Queue", result)
#   ClipClassifierCUI.revert
# ==== コマンドライン例(run)
#   次のファイルを移動しますか?「Y」を入力すると移動します。
#   Clip(src: base/1.Queue/4.txt, like: 7) -> base/Ranked.2021-05-31/4.txt
#   Clip(src: base/1.Queue/3.txt, like: 6) -> base/Ranked.2021-05-31/3.txt
#   Clip(src: base/1.Queue/1.txt, like: 5) -> base/Ranked.2021-05-31/1.txt
#   Clip(src: base/1.Queue/2.txt, like: 5) -> base/2.Revenging/2.txt
#   Clip(src: base/1.Queue/5.txt, like: 5) -> base/2.Revenging/5.txt
#   Clip(src: base/1.Queue/6.txt, like: 1) -> base/3.Unranked/6.txt
#   Clip(src: base/1.Queue/0.txt, like: 0) -> base/3.Unranked/0.txt
#   >>Y
#   移動しました。
# ==== コマンドライン例(revert)
#   ファイルを一つ前の状態に戻しますか?「Y」を入力すると移動します。
#   {"base/Ranked.2021-05-31/4.txt"=>"base/1.Queue/4.txt",
#    "base/Ranked.2021-05-31/3.txt"=>"base/1.Queue/3.txt",
#    "base/Ranked.2021-05-31/1.txt"=>"base/1.Queue/1.txt",
#    "base/2.Revenging/2.txt"=>"base/1.Queue/2.txt",
#    "base/2.Revenging/5.txt"=>"base/1.Queue/5.txt",
#    "base/3.Unranked/6.txt"=>"base/1.Queue/6.txt",
#    "base/3.Unranked/0.txt"=>"base/1.Queue/0.txt"}
#   >>Y
#   移動しました。
module ClipClassifierCUI
  # クリップの仕分けを実施する
  # [+src+] 仕分けたいクリップが格納されているフォルダ
  # [+result+] クリップのファイル名といいね数の対応
  def run(src, result)
    clips = Clip.clips(src, result)
    sorted = ClipClassifier.classify(clips)

    puts "次のファイルを移動しますか?「Y」を入力すると移動します。"
    puts sorted
    print ">>"
    ans = gets.chomp

    if ans == "Y"
      ClipClassifier.save_history(sorted)
      sorted.each(&:commit)
      puts "移動しました。"
    else
      puts "キャンセルされました。"
    end 
  end

  # +config/app_config.json+の+history+に設定しているファイルに書かれている履歴(※)をもとに移動を一つ前の状態に戻す。
  # (※ ClipClassifier.save_history で保存した内容)
  def revert
    File.open(ClipClassifier::HISTORY_PATH) do |f|
      history = JSON.load(f)

      puts "ファイルを一つ前の状態に戻しますか?「Y」を入力すると移動します。"
      PP.pp history
      print ">>"
      ans = gets.chomp
      
      if ans == "Y"
        history.each do |u, v|
          FileUtils.move(u, v)
        end
        puts "移動しました。"
      else
        puts "キャンセルされました。"
      end 
    end
  end

  module_function :run, :revert
end