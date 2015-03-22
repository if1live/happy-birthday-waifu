module MasterData
  class OriginalDataReader
    def initialize(root_path, data_klass)
      @root_path = root_path
      @data_klass = data_klass
    end

    def read
      data_list = []
      Dir.entries(@root_path).each do |dirname|
        next if ['.', '..'].include? dirname
        data_filename = File.join(@root_path, dirname, 'data.yml')
        txt = File.read data_filename
        yaml_data = YAML.load txt

        data = @data_klass.new
        data.from_hash yaml_data
        data_list << data
      end
      data_list
    end

    def self.source_reader
      self.new SOURCE_ROOT, AnimeCharacterDB::SourceData
    end

    def self.character_reader
      self.new CHARACTER_ROOT, AnimeCharacterDB::CharacterData
    end
  end
end
