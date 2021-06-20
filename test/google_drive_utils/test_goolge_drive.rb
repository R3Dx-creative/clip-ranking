require 'test/unit'

require_relative '../../app/lib/google_drive_utils'

class GoogleDriveUtilsTest < Test::Unit::TestCase
  def test_get_session
    session = GoogleDriveUtils::SESSION
    assert_not_nil session
  end

  def test_get_videos
    session = GoogleDriveUtils::SESSION
    videos1 = GoogleDriveUtils.videos("0.Shared", session)
    videos2 = GoogleDriveUtils.videos("0.Shared")

    p videos1
    assert_equal videos1.size, videos2.size
  end
end