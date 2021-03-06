require 'test/unit'

require_relative '../../config/config'
require_relative '../../app/lib/clip'
require_relative '../../app/lib/google_drive_utils'
require_relative '../../app/lib/discord_utils'
require_relative '../../app/lib/history'

class EndtoEndTest < Test::Unit::TestCase
  def test_notify
    # クリップの通知とQueueへの移動
    # POST: /notify
    GoogleDriveUtils.move_all_videos("0.Shared", "1.Queue")
    videos = GoogleDriveUtils.videos("1.Queue").map{ |video| 
      { id: video.id, name: video.name, link: video.web_view_link }
    }
    for video in videos
      DiscordUtils.post_map(video)
    end
    History.save_shared(videos)
  end
  
  def test_classify
    # Queueのフォルダの仕分け
    # POST: /classify
    clip_map = History.load_shared.map{ |video| [video.id, video.name] }.to_h 
    result = DiscordUtils.history(100).filter_map { |message| 
      id = DiscordUtils.content_map(message.content)["id"]
      reaction_size = message.reactions.sum(0) { |reaction| reaction.count }
      [clip_map[id], reaction_size] if id && clip_map.include?(id)
    }.to_h
    clips = Clip.clips("1.Queue", result)
    sorted = ClipClassifier.classify(clips)
    sorted.foreach(&:commit!)
    History.save_classified(sorted)
  end

  def test_concat
    # クリップの結合
    # POST: /concat
    date = History.load_classified["date"]
    ranked_folder = format(ClipClassifier::RANKED_FOLDER, date)
    break_folder = Template::BREAK_FOLDER

    clips = Clip.clips(ranked_folder).sort_by(&:like)
    breaks = Clip.clips(break_folder).sort { |clip1, clip2|  clip2.file <=> clip1.file }
    assets = breakss.zip(clips).flatten

    FFmpegUtils.concat(assets)
  end

  # def test_e2e

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
