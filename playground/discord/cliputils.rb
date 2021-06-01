require 'fileutils'

require_relative '../../app/lib/clip'
require_relative '../../config/config'

# とりあえずクリップを取ってきたい。
module ClipUtils
  @@base = Config["base"]
  @@src = Config["src"]

  # 設定ファイルのsrcに設定されているフォルダ情報からファイルを取得する。
  # [+key+] キー
  def get_files(key)
    src = @@src[key]
    unless src
      return []
    end

    Dir.children("#{@@base}/#{src}")
  end

  module_function :get_files
end

puts ClipUtils.get_files("queue")
