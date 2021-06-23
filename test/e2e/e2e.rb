require 'test/unit'

require_relative '../../app/lib/clip'

class EndtoEndTest < Test::Unit::TestCase
  def test_notify
    # クリップの通知とQueueへの移動
    # POST: /notify
    GoogleDriveUtils.move_all_files("0.Shared", "1.Queue")
    videos = GoogleDriveUtils.videos("1.Queue").map{ |video| 
      { id: video.id, name: video.name, link: video.web_view_link }
    }
    videos.each(DiscordUtils.post_map)
    JsonUtils.save("shared.json", videos)
  end

  # def test_e2e
  #   # 仕分け
  #   # POST: /classify
  #   clip_hash = JsonUtils.load("shared.json").map { |video| [video.id, video.name] }.to_h
  #   result = DiscordUtils.history(100).filter_map { |message| 
  #     id = google_drive_file_id(message.content)
  #     reaction_size = message.reactions.size
  #     [clip_hash[id], reaction_size] if id && clip_pool.include?(id)
  #   }.to_h
  #   clips = Clip.clips("1.Queue", result)
  #   sorted = ClipClassifier.classify(clips)
  #   sorted.foreach(&:commit!)
  #   ClipClassifier::History.save(sorted)

  #   # クリップの結合
  #   # POST: editor/join?folder=[folder]
  #   date = ClipClassifier::History.last_date
  #   ranked_folder = format(ClipClassifier::RANKED_FOLDER, date)
  #   ClipEditor.join(ranked_folder)

  #   # 投稿
  #   # POST: editor/post?file=[file]
  #   date = ClipClassifier::History.last_date
  #   ranked_folder = format(ClipClassifier::RANKED_FOLDER, date) + "/joined.mp4"
  #   ClipEditor.post(ranked_folder)
  # end

  # def test_e2e2
  #   folder = "0.Shared"
  #   shared = Shared.new(folder)
  #   shared.notify

  #   folder = "1.Queue"
  #   queue = Queue.merge(folder, shared)

  #   clips = Queue.load
  #   ClipClassifier.claasify(clips)
  # end
end
