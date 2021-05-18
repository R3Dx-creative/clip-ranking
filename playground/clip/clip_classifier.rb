require './clip'

module ClipClassifier
  def run(clips)
    sorted = Clip.classify(clips)

    puts "次のファイルを移動しますか?「Y」を入力すると移動します。"
    puts sorted
    print ">>"
    ans = gets.chomp

    if ans == "Y"
      sorted.each(&:commit)
      puts "移動しました。"
    else
      puts "キャンセルされました。"
    end 
  end

  module_function :run
end