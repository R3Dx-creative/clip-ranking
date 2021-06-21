require 'test/unit'

require_relative '../../app/lib/clip_messanger'

class ClipMessangerTest < Test::Unit::TestCase
  def test_run
    ClipMessanger.send_view_links("0.Shared")
    ClipMessanger.send_view_links("2.Revenging")
  end
end