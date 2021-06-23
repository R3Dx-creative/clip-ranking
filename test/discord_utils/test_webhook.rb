require 'test/unit'
require 'json'

require_relative '../../app/lib/discord_utils'

class DiscordUtilsTest < Test::Unit::TestCase
  def test_webhook_client
    client = DiscordUtils::WEBHOOK_CLIENT
    assert_not_nil client
  end

  def test_post_map
    client = DiscordUtils::WEBHOOK_CLIENT
    DiscordUtils.post_map({id: 1230, name: "Client in arg"}, client)
    DiscordUtils.post_map({id: 5346, content: "Client not in arg"})
  end
end