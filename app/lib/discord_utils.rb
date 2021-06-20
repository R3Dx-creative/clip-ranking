require 'discordrb/webhooks'

require_relative '../../config/config'

# Discord周りの処理
module DiscordUtils
  # DiscordのWebhoolのURL
  DISCORD_CONFIG = Config["discord"].freeze
  WEBHOOK_URL = DISCORD_CONFIG["webhook_url"].freeze
  CHANNEL_ID = DISCORD_CONFIG["channel_id"].freeze
  # DiscordのWebhookのクライアント
  WEBHOOK_CLIENT = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL).freeze

  # シンプルなメッセージを送るやつ
  def self.send_simple_message(message, client=nil)
    if client.nil?
      client = WEBHOOK_CLIENT
    end

    client.execute do |builder|
      builder.content = message
    end
  end
end