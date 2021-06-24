require 'google_drive'
require 'json'

require_relative '../../config/config'

# Google Drive周りの処理
module GoogleDriveUtils
  # Google Driveにアクセスするための設定ファイルの名前
  CONFIG_FILE = Config["google_drive"]["session_config_file"].freeze
  SESSION = GoogleDrive::Session.from_config(CONFIG_FILE)

  # 動画ファイルを取得する
  # バリデーションはとりあえず考えない(TODO)
  # 動画しか入らない想定なのでファイルの種類のチェックは考えない(TODO)
  def self.videos(folder_name, session=nil)
    session = session || SESSION
    
    folder = session.collection_by_title(folder_name)
    folder.files(q: ["parents in ?", folder.id])
  end

  # srcからdestにファイルをすべて移動する
  def self.move_all_videos(src, dest, session=nil)
    session = session || SESSION

    src_folder = session.collection_by_title(src)
    src_videos = src_folder.files(q: ["parents in ?", src_folder.id])

    dest_folder = session.collection_by_title(dest)
    for video in src_videos
      dest_folder.add(video)
      src_folder.remove(video)
    end
  end

  def self.upload_json(title, map, session=nil)
    session = session || SESSION

    json_string = JSON.dump(map)
    session.upload_from_string(json_string, title)
  end
end