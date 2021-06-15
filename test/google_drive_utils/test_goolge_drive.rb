require 'test/unit'

require_relative '../../app/lib/google_drive_utils'

class GoogleDriveUtilsTest < Test::Unit::TestCase
  def test_get_session
    session = GoogleDriveUtils.get_session
    assert_not_nil session
  end

  def test_get_videos
    session = GoogleDriveUtils.get_session
    videos1 = GoogleDriveUtils.get_videos("0.Shared", session)
    videos2 = GoogleDriveUtils.get_videos("0.Shared")

    p videos1
    assert_equal videos1.size, videos2.size
  end
end