require 'discordrb/webhooks'

require_relative "../../config/config"

WEBHOOK_URL = Config["discord"]["webhook_url"].freeze

client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)
client.execute do |builder|
  builder.content = 'Hello world!'
  builder.add_embed do |embed|
    embed.title = 'Embed title'
    embed.description = 'Embed description'
    embed.timestamp = Time.now
  end
end

