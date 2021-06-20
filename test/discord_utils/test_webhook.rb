require 'test/unit'
require 'json'

require_relative '../../app/lib/discord_utils'

class DiscordUtilsTest < Test::Unit::TestCase
  def test_webhook_client
    client = DiscordUtils::WEBHOOK_CLIENT
    assert_not_nil client
  end

  def test_send_simple_message
    client = DiscordUtils::WEBHOOK_CLIENT
    DiscordUtils.send_simple_message("Client in arg", client)
    DiscordUtils.send_simple_message("Client not in arg")
  end
end