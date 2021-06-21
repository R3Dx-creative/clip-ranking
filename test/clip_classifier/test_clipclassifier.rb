require 'test/unit'

require_relative '../../config/config'
require_relative '../../app/lib/clip_classifier'
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

    # config/local_config.json の base に 同階層のフォルダ test_base のパスを指定してください。
    # FIXME 手動で設定を変えないようにしたい
    ClipClassifierCUI.run("#{Config["base"]}/1.Queue", result)
    assert_equal ClipClassifier::History.last_date, Date.today.strftime("%Y-%m-%d")
    ClipClassifierCUI.revert
  end
end