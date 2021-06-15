require 'test/unit'

require_relative '../../app/lib/clip_messanger'

class ClipMessangerTest < Test::Unit::TestCase
  def test_run
    ClipMessanger.run("0.Shared")
    ClipMessanger.run("2.Revenging")
  end
end