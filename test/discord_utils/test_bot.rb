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

  def test_reactions
    history = DiscordUtils.history(10)
    for message in history
      puts message.reactions
    end
  end

  def test_content_map
    content = '''
    id:1iCdr3cA4Lx\
    name:Apex
    link:https://google.com/
    '''

    mapping = DiscordUtils.content_map(content)
    assert_equal mapping["id"], '1iCdr3cA4Lx\\'
    assert_equal mapping["name"], "Apex"
    assert_equal mapping["link"], "https://google.com/"
  end
end