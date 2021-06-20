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

  # シンプルなメッセージを送るやつ
  def self.send_simple_message(message, client=nil)
    if client.nil?
      client = WEBHOOK_CLIENT
    end

    client.execute do |builder|
      builder.content = message
    end
  end

  # メッセージ取得するやつ
  def self.history(amount, channel=nil)
    if channel.nil?
      channel = CHANNEL
    end

    channel.history(amount)
  end
end