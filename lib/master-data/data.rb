module MasterData
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

    def fullwidth_to_halfwidth(val)
      char_table = [
        ['（', '('],
        ['）', ')'],
        ['　', ' ']
      ]
      char_table.each do |before, after|
        val = val.gsub before, after
      end
      val
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
        'title_jp' => fullwidth_to_halfwidth(data.title_jp),
        'title_romaji' => data.title_romaji,
        'title_furigana' => fullwidth_to_halfwidth(data.title_furigana),

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

    def predefined_birthday_table
      if @predefined_birthday_cache.nil?
        data_file = 'predefined_birthday.yml'
        data_filepath = File.join File.dirname(__FILE__), data_file
        @predefined_birthday_cache = YAML.load_file data_filepath
      end
      @predefined_birthday_cache
    end

    def predefined_name_ko_table
      if @predefined_name_ko_cache.nil?
        data_file = 'predefined_name_ko.yml'
        data_filepath = File.join File.dirname(__FILE__), data_file
        @predefined_name_ko_cache = YAML.load_file data_filepath
      end
      @predefined_name_ko_cache
    end

    def create_seed_key(id)
      "character_#{id}"
    end

    def skip_data?(data)
      # 생일이 없는 캐릭터는 굳이 다룰 필요가 없다...
      filtered_birthday(data) == nil
    end

    def filtered_birthday(data)
      if data.birthday.nil?
        if predefined_birthday_table.include?(data.name_en)
          predefined_birthday_table[data.name_en]
        else
          nil
        end
      else
        data.birthday
      end
    end

    def filtered_name_ko(data)
      if predefined_name_ko_table.include?(data.name_en)
        predefined_name_ko_table[data.name_en]
      else
        data.name_ko
      end
    end

    def data_to_hash(data)
      {
        'id' => nil,

        'slug' => data.create_slug,
        'name_en' => data.name_en,
        'name_jp' => fullwidth_to_halfwidth(data.name_jp),
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
end
