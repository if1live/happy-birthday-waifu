require 'yaml'
require 'anime-character-db-crawler'

namespace :master_data do
  SEED_ROOT = Rails.root.join 'db', 'seeds'
  ANIME_CHARACTER_DB_ROOT = Rails.root.join 'anime-character-db'
  SOURCE_ROOT = ANIME_CHARACTER_DB_ROOT.join 'source'
  CHARACTER_ROOT = ANIME_CHARACTER_DB_ROOT.join 'character'

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


  module MasterDataModule
    def initialize(seed)
      @master_data = seed
      @next_seed_idx = last_seed_idx + 1
    end

    def merge(data)
      return if skip_data? data

      seed_data = data_to_hash data
      data_key = find_data_unique_key data
      seed_key = find_seed_key data_key
      if seed_key.nil?
        # 새로 저장해야되는 경우
        # puts "merge new data #{seed_key} #{data_key}"
        merge_new_data seed_data
      else
        # 기존에 저장된 것이 존재하는 경우
        # puts "merge prev data #{seed_key} #{data_key}"
        merge_prev_data seed_key, seed_data
      end
    end

    def add_seed_id(seed_key, seed_data)
      seed_idx = seed_idx_from_seed_key seed_key
      seed_data['id'] = seed_idx if seed_data['id'].nil?
      seed_data
    end

    def merge_new_data(seed_data)
      seed_key = create_seed_key(@next_seed_idx)
      @next_seed_idx += 1

      add_seed_id(seed_key, seed_data)
      @master_data[seed_key] = seed_data
    end

    def merge_prev_data(seed_key, seed_data)
      add_seed_id(seed_key, seed_data)
      @master_data[seed_key] = seed_data
    end

    def to_seed
      @master_data
    end

    def find_seed_key(data_key)
      @master_data.each do |key, value|
        if find_data_key_from_seed(value) == data_key
          return key
        end
      end
      nil
    end

    def seed_idx_from_seed_key(seed_key)
      seed_key.split('_')[-1].to_i
    end

    def last_seed_idx
      if @master_data.empty?
        0
      else
        # "11" < "2",  왜냐하면 숫자가 아니라 문자열이니까
        # master_data 에서 뽑은 키를 그대로 비교하면 위의 문제가 발생하기 때문에
        # string key 에서 integer 를 뽑아내고 이것을 이용해야한다
        num_array = @master_data.keys.map { |x| x.split('_')[-1].to_i }
        num_array.reverse[0]
      end
    end
  end

  class SourceMasterData
    include MasterDataModule

    def create_seed_key(id)
      "source_#{id}"
    end

    def skip_data?(data)
      false
    end

    def data_to_hash(data)
      {
        'id' => data.src_id,

        'slug' => data.create_slug,
        'title_en' => data.title_en,
        'title_jp' => data.title_jp,
        'title_romaji' => data.title_romaji,
        'title_furigana' => data.title_furigana,

        'anime_db_id' => data.src_id,
      }
    end

    def find_data_unique_key(data)
      data.src_id
    end

    def find_data_key_from_seed(seed)
      seed['anime_db_id']
    end
  end

  class CharacterMasterData
    include MasterDataModule

    # 러브라이브 캐릭 같은 경우 생일이 기록 안되있더라?
    # 없는 경우 수동으로 생일 목록 관리해야될듯 -_-
    # 크롤링 결과는 나중에 재생성 가능하니까 코드(또는 데이터로 분리해야된다)
    PREDEFINED_BIRTHDAY_TABLE = {
      # love live
      'Eri Ayase' => '10/21',
      'Hanayo Koizumi' => '01/17',
      'Honoka Kousaka' => '08/03',
      'Nico Yazawa' => '07/22',
      'Maki Nishikino' => '04/19',
      'Kotori Minami' => '09/12',
      'Nozomi Toujou' => '06/09',
      'Rin Hoshizora' => '11/01',
      'Umi Sonoda' => '03/15',

      # Yuki Yuna is a Hero
      'Yuuna Yuuki' => '03/21',
    }

    PREDEFINED_NAME_KO_TABLE = {
      'Eri Ayase' => '아야세 에리',
      'Rin Hoshizora' => '호시조라 린',
      'Nozomi Toujou' => '토죠 노조미',
      'Hanayo Koizumi' => '코이즈미 하나요',
      'Yuuna Yuuki' => '유우키 유우나',
    }

    def create_seed_key(id)
      "character_#{id}"
    end

    def skip_data?(data)
      # 생일이 없는 캐릭터는 굳이 다룰 필요가 없다
      filtered_birthday(data) == nil
    end

    def filtered_birthday(data)
      if data.birthday.nil?
        if PREDEFINED_BIRTHDAY_TABLE.include?(data.name_en)
          PREDEFINED_BIRTHDAY_TABLE[data.name_en]
        else
          nil
        end
      else
        data.birthday
      end
    end

    def filtered_name_ko(data)
      if PREDEFINED_NAME_KO_TABLE.include?(data.name_en)
        PREDEFINED_NAME_KO_TABLE[data.name_en]
      else
        data.name_ko
      end
    end

    def data_to_hash(data)
      {
        'id' => nil,

        'slug' => data.create_slug,
        'name_en' => data.name_en,
        'name_jp' => data.name_jp,
        'name_ko' => filtered_name_ko(data),
        'date' => filtered_birthday(data),

        'anime_db_id' => data.character_id,
        'anime_db_img_url' => data.image,

        'source_id' => data.source_id,
      }
    end

    def find_data_unique_key(data)
      data.character_id
    end

    def find_data_key_from_seed(seed)
      seed['anime_db_id']
    end
  end

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

  def create_source_seed
    source_list = OriginalDataReader.source_reader.read
    source_serializer = SeedSerializer.create_source
    source_seed = source_serializer.read
    source_master_data = SourceMasterData.new source_seed
    source_list.each do |data|
      source_master_data.merge data
    end
    source_serializer.write source_master_data.to_seed
  end

  def create_character_seed
    # character
    character_list = OriginalDataReader.character_reader.read
    character_serializer = SeedSerializer.create_character
    character_seed = character_serializer.read
    character_master_data = CharacterMasterData.new character_seed
    character_list.each do |data|
      character_master_data.merge data
    end
    character_serializer.write character_master_data.to_seed
  end

  "create db/seeds/*.yml"
  task create: :environment do
    create_source_seed
    create_character_seed
  end
end
