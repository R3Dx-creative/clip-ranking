require 'json'
require 'pp'
require 'date'

require_relative '../lib/clip'
require_relative '../../config/config'

module ClipClassifier
  @@base = Config["base"]
  @@border = Config["border"]
  @@ranking_n = Config["ranking_n"]
  @@dest = Config["dest"]
  @@unranked_folder = @@dest["unranked"]
  @@revenging_folder = @@dest["revenging"]
  @@ranked_folder = format(@@dest["ranked"], Date.today.strftime("%Y-%m-%d"))
  @@history_file = Config["history_file"]

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

  def run(clips)
    sorted = classify(clips)

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

    File.open("#{@@base}/#{@@history_file}", "w") do |f|
      JSON.dump(history, f)
    end
  end

  def revert
    File.open("#{@@base}/#{@@history_file}") do |f|
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

  module_function :classify, :run, :save_history, :revert
end