require 'test/unit'

require_relative '../../app/lib/discord_utils'

class DiscordUtilsTest < Test::Unit::TestCase
  def test_get_client
    client = DiscordUtils.get_client
    assert_not_nil client
  end

  def test_send_simple_message
    client = DiscordUtils.get_client
    DiscordUtils.send_simple_message("Client in arg", client)
    DiscordUtils.send_simple_message("Client not in arg")
  end
end