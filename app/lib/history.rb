require_relative '../../config/config'

module History
  BASE = Config["base"].freeze
  HISTORY_CONFIG = Config["history"].freeze
  SHARED = "#{BASE}/#{HISTORY_CONFIG["shared"]}".freeze
  CLASSIFIED = "#{BASE}/#{HISTORY_CONFIG["classified"]}".freeze

  # 共有したクリップ情報を保存する
  # [+shared_clips+] 共有した情報(id, name, link のHash)
  def self.save_shared(shared_clips)
    File.open(SHARED, "w") do |f|
      JSON.dump(shared_array, f)
    end
  end

  # 仕分けの情報を保存する
  # [+clips+] クリップ集(Clip)
  def self.save_classified(clips)
    clip_history = clips
      .map { |clip| [clip.dest_path, clip.src_path] }
      .to_h

    File.open(CLASSIFIED, "w") do |f|
      JSON.dump({date: Date.today.strftime("%Y-%m-%d"), history: clip_history}, f)
    end
  end

  # 共有したクリップ情報を読み込む(オブジェクト)
  def self.load_shared
    File.open(SHARED) { |f| JSON.load(f) }
  end

  # 仕分けした情報を読み込む(オブジェクト)
  def self.load_classified
    File.open(CLASSIFIED) { |f| JSON.load(f) }
  end
end