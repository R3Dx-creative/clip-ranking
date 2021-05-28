require 'json'
require 'pp'
require 'date'

require_relative '../lib/clip'
require_relative '../lib/clip_classifier'
require_relative '../../config/config'

module ClipClassifierCUI
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

  def revert
    File.open(ClipClassifier.history_path) do |f|
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