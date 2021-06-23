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

    assert_equal videos1.size, videos2.size
  end

  def test_move_all_files
    GoogleDriveUtils.move_all_videos("0.Shared", "1.Queue")
    videos = GoogleDriveUtils.videos("1.Queue")
    assert_not_equal videos.size, 0

    GoogleDriveUtils.move_all_videos("1.Queue", "0.Shared")
    videos = GoogleDriveUtils.videos("1.Queue")
    assert_equal videos.size, 0
  end
end