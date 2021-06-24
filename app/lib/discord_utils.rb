require 'discordrb/webhooks'
require 'discordrb'

require_relative '../../config/config'

# Discord周りの処理。設定ファイルからクライアントやチャンネルを作成する。
module DiscordUtils
  DISCORD_CONFIG = Config["discord"].freeze
  WEBHOOK_URL = DISCORD_CONFIG["webhook_url"].freeze
  SERVER_ID = DISCORD_CONFIG["server_id"].freeze
  CHANNEL_ID = DISCORD_CONFIG["channel_id"].freeze
  TOKEN = DISCORD_CONFIG["token"].freeze

  # DiscordのWebhookのクライアント
  WEBHOOK_CLIENT = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL).freeze

  # チャンネル
  CHANNEL = Discordrb::Channel.new(
    JSON.parse(Discordrb::API::Channel.resolve(TOKEN, CHANNEL_ID).body), 
    Discordrb::Bot.new(token: TOKEN)
  ).freeze

  # Hashをメッセージにして送る
  def self.post_map(contents_map, client=nil)
    client ||= WEBHOOK_CLIENT

    message = contents_map.map { |key, value| 
      "#{key}:#{value}"
    }.join("\n")

    client.execute do |builder|
      builder.content = message
    end
  end

  # メッセージ取得する
  def self.history(amount, channel=nil)
    client ||= WEBHOOK_CLIENT

    channel.history(amount)
  end
end