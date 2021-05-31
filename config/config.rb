require 'json'

# 設定値を取得するクラス。+local_config.json+と+app_config.json+から設定値を読み込む。<tt>Config[設定値のキー]</tt>で設定値を取得する。

class Config
  @@local_config = File.open("#{__dir__}/local_config.json") { |f| JSON.load(f) }
  @@config = File.open("#{__dir__}/app_config.json") { |f| JSON.load(f) }.merge(@@local_config)
  
  # 設定値の取得
  def self.[](s)
    @@config[s]
  end
end