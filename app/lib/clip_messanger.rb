require_relative './discord_utils'
require_relative './google_drive_utils'

module ClipMessanger
  def run(folder_name)
    links = GoogleDriveUtils.get_videos(folder_name).map(&:web_view_link)
    for link in links
      DiscordUtils.send_simple_message(link)
      sleep 2.0
    end
  end

  module_function :run
end