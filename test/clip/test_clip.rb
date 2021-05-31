require 'test/unit'

require_relative '../../app/lib/clip'

BASE = __dir__

class ClipTest < Test::Unit::TestCase
  @@dir = "#{BASE}/test_resources"
  @@dest = "#{BASE}/test_dest"
  @@file = (0..2).map { |i| "#{i}.txt"}

  def init(i, like)
    Clip.new(@@dir, "#{i}.txt", like)
  end
  
  def test_clip_attr
    clip = init(0, 0)
    assert_equal [@@file[0], 0], [clip.file, clip.like]
  end

  def test_clip_src_path
    clip = init(0, 0)
    assert_equal "#{@@dir}/#{@@file[0]}", clip.src_path
  end

  def test_clip_move
    clip = init(0, 0)
    clip.move!(@@dest)
    assert_equal "#{@@dest}/#{@@file[0]}", clip.dest_path
  end

  def test_to_s
    clip = init(0, 0)
    expect = "Clip(src: #{clip.src_path}, like: 0)"
    assert_equal expect, clip.to_s
    puts clip

    clip.move!(@@dest)
    assert_equal "#{expect} -> #{clip.dest_path}", clip.to_s
    puts clip
  end

  def test_equal
    clip1 = init(0, 0)
    clip2 = init(0, 0)
    clip3 = init(1, 0)
    clip4 = init(0, 1)
    assert_equal clip1, clip2
    assert_not_equal clip1, clip3
    assert_not_equal clip1, clip4

    clip1.move!(@@dest)
    assert_not_equal clip1, clip2

    clip2.move!(@@dest)
    assert_equal clip1, clip2
  end

  def test_clips
    expect_clips = [init(0, 1), init(1, 4), init(2, 2)]
    
    result = @@file.zip([1, 4, 2]).to_h
    actual_clips = Clip.clips(@@dir, result)

    assert_equal expect_clips, actual_clips
    puts actual_clips
  end

  def test_commit
    clip = init(0, 0)
    clip.move!(@@dest)
    clip.commit

    assert_equal Dir.children(@@dir), @@file[1..2]
    assert_equal Dir.children(@@dest), [@@file[0]]

    clip = Clip.new(@@dest, @@file[0], 0)
    clip.move!(@@dir)
    clip.commit
    assert_equal Dir.children(@@dir), @@file
  end
end