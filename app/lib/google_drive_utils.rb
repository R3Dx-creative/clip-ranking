require 'google_drive'

require_relative '../../config/config'

# Google Drive周りの処理
module GoogleDriveUtils
  # Google Driveにアクセスするための設定ファイルの名前
  @GOOGLE_DRIVE_CONFIG_FILE = Config["google_drive"]["session_config_file"].freeze
  @session = GoogleDrive::Session.from_config(@GOOGLE_DRIVE_CONFIG_FILE) 
  
  # Google Driveに接続するセッション(シングルトン)
  def get_session
    @session
  end

  # 動画ファイルを取得するやつ
  # バリデーションはとりあえず考えない(TODO)
  # 動画しか入らない想定なのでファイルの種類のチェックは考えない(TODO)
  def get_videos(folder_name, session=nil)
    if session.nil?
      session = @session
    end
    
    folder = session.files(q: "name = '#{folder_name}'")[0]
    session.files(q: "parents in '#{folder.id}'")
  end
  
  module_function :get_videos, :get_session
end