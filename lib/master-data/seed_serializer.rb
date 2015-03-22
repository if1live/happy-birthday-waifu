module MasterData
  class SeedSerializer
    def initialize filename
      @filename = File.join(SEED_ROOT, filename)
    end

    def read
      return {} unless File.exists? @filename
      txt = File.read @filename
      seed = YAML.load txt
    end

    def write seed
      txt = YAML.dump seed
      File.write @filename, txt
    end

    def self.create_source
      self.new 'sources.yml'
    end

    def self.create_character
      self.new 'characters.yml'
    end
  end
end
