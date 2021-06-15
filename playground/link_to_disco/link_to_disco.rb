require 'discordrb/webhooks'
require 'google_drive'

require_relative "../../config/config"

# 各種設定情報
# セキュリティ確保のため、ローカルだけに情報をもって、公開しない

# DiscordのWebhoolのURL
WEBHOOK_URL = Config["discord"]["webhook_url"].freeze
# Google Driveにアクセスするための設定ファイルの名前
GOOGLE_DRIVE_CONFIG_FILE = Config["google_drive"]["session_config_file"].freeze

# Google Drive周りの処理
module GoogleDriveUtils
  # 動画ファイルを取得するやつ
  # バリデーションはとりあえず考えない(TODO)
  # 動画しか入らない想定なのでファイルの種類のチェックは考えない(TODO)
  def get_videos(session, folder_name)
    folder = session.files(q: "name = '#{folder_name}'")[0]
    session.files(q: "parents in '#{folder.id}'")
  end
  
  module_function :get_videos
end

# Discord周りの処理
module DiscordUtils
  # シンプルなメッセージを送るやつ
  def send_simple_message(client, message)
    client.execute do |builder|
      builder.content = message
    end
  end

  module_function :send_simple_message
end

def main
  # Google Driveのセッション
  session = GoogleDrive::Session.from_config(GOOGLE_DRIVE_CONFIG_FILE)
  # DiscordのWebhookのクライアント
  client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)

  # 0.Shared内の動画ファイルを取得して、それぞれのリンクを取得
  links = GoogleDriveUtils.get_videos(session, "0.Shared").map(&:web_view_link)
  for link in links
    DiscordUtils.send_simple_message(client, link)
    sleep 2.0
  end
end

main