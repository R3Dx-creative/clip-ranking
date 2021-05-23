require '../../app/cui/clip_classifier'
require '../../app/lib/clip'
require '../../config/config'

def main
  result = {
    "0.txt" => 0,
    "1.txt" => 5,
    "2.txt" => 5,
    "3.txt" => 6,
    "4.txt" => 7,
    "5.txt" => 5,
    "6.txt" => 1
  }

  clips = Clip.clips("#{Config["base"]}/1.Queue", result)
  ClipClassifier.run(clips)
  ClipClassifier.revert
end

main