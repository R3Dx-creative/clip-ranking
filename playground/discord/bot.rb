require 'discordrb'

require_relative "../../config/config"

bot = Discordrb::Bot.new(token: Config["discord"]["token"])
puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'
bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!Pong!Ping!'
end

bot.run
