require 'google_drive'

require_relative '../../config/config'

# Google Drive周りの処理
module GoogleDriveUtils
  # Google Driveにアクセスするための設定ファイルの名前
  CONFIG_FILE = Config["google_drive"]["session_config_file"].freeze
  SESSION = GoogleDrive::Session.from_config(CONFIG_FILE)

  # 動画ファイルを取得するやつ
  # バリデーションはとりあえず考えない(TODO)
  # 動画しか入らない想定なのでファイルの種類のチェックは考えない(TODO)
  def self.videos(folder_name, session=nil)
    if session.nil?
      session = SESSION
    end
    
    folder = session.collection_by_title(folder_name)
    folder.files(q: ["parents in ?", folder.id])
  end
end