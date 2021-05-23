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
  @@history_path = "#{@@base}/#{@@history_file}"

  def history_path
    @@history_path
  end

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