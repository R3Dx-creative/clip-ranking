require 'test/unit'
require 'json'

require_relative '../../app/lib/discord_utils'

class DiscordUtilsTest < Test::Unit::TestCase
  def test_channel
    channel = DiscordUtils::CHANNEL
    assert_not_nil channel
  end

  def test_history
    history = DiscordUtils.history(10)
    assert_equal history.size, 10
  end
end