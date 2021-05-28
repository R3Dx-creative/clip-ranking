require 'test/unit'

require_relative '../../app/cui/clip_classifier_cui'

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

    ClipClassifierCUI.run("#{__dir__}/test_base/1.Queue", result)
    ClipClassifierCUI.revert
  end
end