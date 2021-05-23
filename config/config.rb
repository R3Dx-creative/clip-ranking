require 'json'

class Config
  @@local_config = File.open("#{__dir__}/local_config.json") { |f| JSON.load(f) }
  @@config = File.open("#{__dir__}/app_config.json") { |f| JSON.load(f) }.merge(@@local_config)
  
  def self.[](s)
    @@config[s]
  end
end