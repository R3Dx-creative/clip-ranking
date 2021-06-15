require "google_drive"

require_relative "../../config/config"

# GoogleDriveにアクセスするための設定ファイルの名前を取得
# セキュリティ確保のため、ローカルだけに情報をもって、公開しない
json = Config["google_drive"]["session_config_file"]

# セッションを取得
session = GoogleDrive::Session.from_config(json)

# 動画リンクを取得するやつ
# バリデーションはとりあえず考えない(TODO)
# 動画しか入らない想定なのでファイルの種類のチェックは考えない(TODO)
def get_video_links(session, folder_name)
  folder = session.files(q: "name = '#{folder_name}'")[0]
  
  session.files(q: "parents in '#{folder.id}'").map(&:web_view_link)
end

puts get_video_links(session, "0.Shared")
