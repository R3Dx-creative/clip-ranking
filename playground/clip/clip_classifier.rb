require 'json'
require 'pp'

require './clip'
require './config'


module ClipClassifier
  @@history_file = Config.get("history_file")

  def run(clips)
    sorted = Clip.classified(clips)

    puts "次のファイルを移動しますか?「Y」を入力すると移動します。"
    puts sorted
    print ">>"
    ans = gets.chomp

    if ans == "Y"
      save_history(sorted)
      sorted.each(&:commit)
      puts "移動しました。"
    else
      puts "キャンセルされました。"
    end 
  end

  def save_history(clips)
    history = clips
      .map { |clip| [clip.dest_path, clip.src_path] }
      .to_h

    File.open(@@history_file, "w") do |f|
      JSON.dump(history, f)
    end
  end

  def revert
    File.open(@@history_file) do |f|
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

  module_function :run, :save_history, :revert
end