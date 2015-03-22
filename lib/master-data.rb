require 'master-data/base'
require 'master-data/data'
require 'master-data/seed_serializer'
require 'master-data/data_reader'

module MasterData
  SEED_GEN_TABLE = {
    source: {
      data_reader: OriginalDataReader.source_reader,
      seed_serializer: SeedSerializer.create_source,
      master_data_klass: SourceMasterData
    },
    character: {
      data_reader: OriginalDataReader.character_reader,
      seed_serializer: SeedSerializer.create_character,
      master_data_klass: CharacterMasterData
    }
  }

  def self.create_seed(category)
    data_reader = SEED_GEN_TABLE[category][:data_reader]
    seed_serializer = SEED_GEN_TABLE[category][:seed_serializer]
    master_data_klass = SEED_GEN_TABLE[category][:master_data_klass]

    data_list = data_reader.read
    seed = seed_serializer.read
    master_data = master_data_klass.new seed
    data_list.each do |data|
      master_data.merge data
    end
    seed_serializer.write master_data.to_seed
  end
end
