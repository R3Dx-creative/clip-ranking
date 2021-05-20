require 'json'

class Config
  @@config = File.open("config.json") { |f| JSON.load(f) }
  
  def self.get(s)
    @@config[s]
  end
end