require 'nokogiri'

module AnimeCharacterDB
  class SimpleCharacterData
    # character parser를 돌릴때 필요한 최소 정보만 남아있는 자료구조
    attr_reader :character_id,
                :name_en

    def initialize(character_id, name_en)
      @character_id = character_id
      @name_en = name_en
    end

    def ==(o)
      character_id == o.character_id and name_en == o.name_en
    end

    def to_hash
      {
        character_id: @character_id,
        name_en: @name_en,
      }
    end

    def from_hash hash
      @character_id = hash[:character_id]
      @name_en = hash[:name_en]
    end
  end

  class SourceData < BaseData
    # required
    integer_attr_accessor :src_id
    attr_accessor :title_en,
                  :title_jp,
                  :title_romaji,
                  :title_furigana
    tags_attr_accessor :aliases

    attr_accessor :studio_jp,
                  :studio_en,
                  :content_rating,
                  :release_date
    tags_attr_accessor :genre_tags

    attr_accessor :img_thumbnail
    attr_reader :characters

    def initialize
      @characters = []
    end

    def create_slug
      convert_slug @title_en
    end

    def release_date=(val)
      @release_date = Date.parse(val)
    end

    def <<(val)
      @characters << val
    end

    SERIALIZE_ATTR_NAME_LIST = [
      :src_id,
      :title_en,
      :title_jp,
      :title_romaji,
      :title_furigana,
      :aliases,
      :studio_jp,
      :studio_en,
      :content_rating,
      :release_date,
      :genre_tags,
      :img_thumbnail,
    ]

    def to_hash
      hash = to_hash_core SERIALIZE_ATTR_NAME_LIST
      # characters 는 그냥 저장하면 object 상태로 저장된다
      # 따로 직렬화 수행
      hash[:characters] = []
      @characters.each do |x|
        hash[:characters] << x.to_hash
      end
      hash
    end

    def from_hash(hash)
      from_hash_core hash, SERIALIZE_ATTR_NAME_LIST
      hash[:characters].each do |x|
        character = SimpleCharacterData.new
        character.from_hash x
        self << character
      end
    end
  end


  class SourceHTMLParser
    def initialize()
      @doc = nil
    end

    def read html
      doc = Nokogiri::HTML.parse(html) do |config|
        config.options = Nokogiri::XML::ParseOptions::NOBLANKS
      end

      data = SourceData.new
      read_basic_info doc, data
      read_thumbnail doc, data, html
      read_characters doc, data
      data
    end

    def read_thumbnail doc, data, html
      a_list = doc.css('a')
      a_list.each do |a_node|
        expected_href = "source.php?id=#{data.src_id}"
        if a_node.get_attribute(:href) == expected_href
          img_node = a_node.css('img')[0]
          data.img_thumbnail = img_node.get_attribute('src')
          return data
        end
      end
      raise ArgumentError.new "cannot find thumbnail"
      data
    end

    def read_characters doc, data
      a_list = doc.css('#tile1 a')
      a_list.each do |elem|
        name_en = elem.inner_text
        next if name_en.empty?
        href = elem.get_attribute :href
        character_id = href.gsub('character.php?id=', '').to_i
        chara = SimpleCharacterData.new character_id, name_en
        data << chara
      end
      data
    end

    def find_info_table_node doc
      elem = doc.css('h3')[0]
      curr = elem.next_sibling
      while not curr.nil? do
        node_name = curr.node_name
        id_val = curr.get_attribute :id
        if node_name == 'div' && id_val == 'besttable'
          table_node = curr.css('table')[0]
          return table_node
        end
        curr = curr.next_sibling
      end
    end

    def read_basic_info(doc, data)
      attr_table = {
        'Series ID' => :src_id,
        'English Title' => :title_en,
        'Aliases' => :aliases,
        'Romaji Title' => :title_romaji,
        'Furigana Title' => :title_furigana,
        'Japanese Title' => :title_jp,
        'Japanese Studio Name' => :studio_jp,
        'English Studio Name' => :studio_en,
        'Content Rating' => :content_rating,
        'Genre Tags' => :genre_tags,
        'Release Date' => :release_date,
      }

      table = find_info_table_node doc
      tr_list = table.css('tr')
      tr_list.each do |tr_node|
        th_node = tr_node.css('th')[0]
        td_node = tr_node.css('td')[0]

        key = th_node.inner_text
        value = td_node.inner_text
        #puts "#{key} = #{value}"
        next unless attr_table.include? key

        attr_name = attr_table[key]
        data.send("#{attr_name}=", value)
      end
      data
    end
  end
end
