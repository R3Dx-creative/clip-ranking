require 'yaml'

class Config
  @@config = YAML.load_file("config.yaml")
  
  def self.get(s)
    @@config[s]
  end
end