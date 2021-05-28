require 'test/unit'

require_relative '../../app/cui/clip_classifier_cui'
require_relative '../../app/lib/clip'

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

    # config/local_config.json の base にフォルダ test_base を設定してください。
    ClipClassifierCUI.run("#{Config["base"]}/1.Queue", result)
    ClipClassifierCUI.revert
  end
end