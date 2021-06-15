require 'discordrb/webhooks'

require_relative '../../config/config'

# Discord周りの処理
module DiscordUtils
  # DiscordのWebhoolのURL
  @WEBHOOK_URL = Config["discord"]["webhook_url"].freeze
  # DiscordのWebhookのクライアント
  @client = Discordrb::Webhooks::Client.new(url: @WEBHOOK_URL)

  # DiscordのWebhookでメッセージを送るためのクライアント(シングルトン)
  def get_client
    @client
  end

  # シンプルなメッセージを送るやつ
  def send_simple_message(message, client=nil)
    if client.nil?
      client = @client
    end

    client.execute do |builder|
      builder.content = message
    end
  end

  module_function :send_simple_message, :get_client
end