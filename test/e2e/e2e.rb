require 'test/unit'

require_relative '../../app/lib/clip'

class EndtoEndTest < Test::Unit::TestCase
  def test_e2e
    # Queueに移動
    # POST: /enqueue
    clips = Clip.clips("0.Shared")
    clips.concat(Clip.clips("2.Revenging"))
    for clip in clips
      clip.move!("1.Queue", :force)
    end
    ClipClassifier::Hisroty.save(clips, :queue)

    # クリップの通知
    # POST: /message?folder=[folder]
    folder = "1.Queue"
    ClipMessanger.send_view_links(folder)

    # ランキング集計
    # GET: /aggregate?date=[date]
    date = ClipClassifier::History.last_date
    result = ClipAggregator.aggregate(date)

    # 仕分け
    # POST: /classify, bodyにresult
    clips = Clip.clips("1.Queue", result)
    sorted = ClipClassifier.classify(clips)
    sorted.foreach(&:commit!)
    ClipClassifier::History.save(sorted, :claasified)

    # クリップの結合
    # POST: editor/join?folder=[folder]
    date = ClipClassifier::History.last_date
    ranked_folder = format(ClipClassifier::RANKED_FOLDER, date)
    ClipEditor.join(ranked_folder)

    # 投稿
    # POST: editor/post?file=[file]
    date = ClipClassifier::History.last_date
    ranked_folder = format(ClipClassifier::RANKED_FOLDER, date) + "/joined.mp4"
    ClipEditor.post(ranked_folder)
  end
end
