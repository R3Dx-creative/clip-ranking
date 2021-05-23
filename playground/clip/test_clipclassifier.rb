require 'test/unit'
require './clip_classifier'
require './clip'

class ClipClassifierTest < Test::Unit::TestCase
  def test_classify
    result = {
      "0.txt" => 0,
      "1.txt" => 5,
      "2.txt" => 5,
      "3.txt" => 6,
      "4.txt" => 7,
      "5.txt" => 5,
      "6.txt" => 1
    }

    clips = Clip.clips("1.Queue", result)
    ClipClassifier.run(clips)
    ClipClassifier.revert
  end
end