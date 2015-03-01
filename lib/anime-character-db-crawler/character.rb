require 'nokogiri'

module AnimeCharacterDB
  class CharacterData < BaseData
    # required
    integer_attr_accessor :character_id
    attr_accessor :name_en,
                  :name_jp,
                  :birthday
    tags_attr_accessor :aliases
    attr_reader :name_kanji,
                :name_kana,
                :name_ko

    # predefined
    attr_accessor :role,
                  :cv,
                  :type,
                  :blood_type
    tags_attr_accessor :tags
    tags_attr_accessor :voice_actors

    # image
    attr_accessor :thumbnail,
                  :image

    # source
    integer_attr_accessor :source_id
    attr_accessor :source_name,
                  :source_image

    def parse_name_jp(val)
      # 春日野 穹 （かすがの そら）
      regexp = /(?<kanji>.+)（(?<kana>.+)）/
      m = regexp.match val

      name_kanji = nil
      name_kana = nil
      unless m.nil?
        name_kanji = m.captures[0].strip
        name_kana = m.captures[1].strip
      else
        # only kanji or only kana
        hira_match = /\p{Hiragana}/.match(val)
        kata_match = /\p{Katakana}/.match(val)
        if hira_match.nil? and kata_match.nil?
          # 山川 美千子
          name_kanji = val
        else
          # イリーナ・ウラジーミロヴナ・プチナ
          name_kana = val
        end
      end
      {
        kanji: name_kanji,
        kana: name_kana
      }
    end

    def name_kanji
      parse_name_jp(@name_jp)[:kanji]
    end

    def name_kana
      parse_name_jp(@name_jp)[:kana]
    end

    def name_ko
      # TODO kana없는 경우 영어 표기법에서 한글을 추정해야한다
      unless name_kana.nil?
        converter = KanaToHangul.new
        converter.convert name_kana
      end
    end

    def birthday=(val)
      month_table = {
        january: 1,
        february: 2,
        march: 3,
        april: 4,
        may: 5,
        june: 6,
        july: 7,
        august: 8,
        september: 9,
        october: 10,
        november: 11,
        december: 12
      }
      unless val.nil?
        token_list = val.split(' ')
        raise ArgumentError.new "unknown date format" unless token_list.length == 2

        month_key = token_list[0].downcase.to_sym
        month = month_table[month_key]
        raise ArgumentError.new "unknwon month, #{month_key}" if month.nil?

        day = token_list[1].to_i

        @birthday = sprintf("%02d/%02d", month, day)
      end
    end

    SERIALIZE_ATTR_NAME_LIST = [
      :character_id,
      :name_en,
      :name_jp,
      :birthday,
      :aliases,
      :role,
      :cv,
      :type,
      :blood_type,
      :tags,
      :voice_actors,
      :thumbnail,
      :image,
      :source_id,
      :source_name,
      :source_image
    ]

    def to_hash
      to_hash_core SERIALIZE_ATTR_NAME_LIST
    end

    def from_hash(hash)
      from_hash_core hash, SERIALIZE_ATTR_NAME_LIST
    end
  end


  class CharacterHTMLParser
    def initialize()
      @doc = nil
    end

    def get_content_table(doc, header)
      h3_list = doc.css('h3')
      h3_list.each do |elem|
        if elem.inner_text == header
          # find property table
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
      end

    end

    def get_profile_table(doc)
      get_content_table doc, 'Profile'
    end

    def filter_profile_key(key)
      key = key.gsub '(more)', ''
      key = key.downcase
      key = key.strip
      key = key.gsub ' ', '_'
      key.to_sym
    end

    def filter_profile_value(value)
      value = value.strip
      if value == ''
        nil
      else
        value
      end
    end

    def read html
      doc = Nokogiri::HTML.parse(html) do |config|
        config.options = Nokogiri::XML::ParseOptions::NOBLANKS
      end

      metadata = CharacterData.new
      read_profile doc, metadata
      read_thumbnail doc, metadata
      read_image doc, metadata
      read_source doc, metadata

      metadata
    end

    def read_source(doc, metadata)
      img_node_list = doc.css('img')
      img_node_list.each do |el|
        src = el.get_attribute :src
        next unless src.include? 'ami.animecharactersdatabase.com'
        next unless src.include? '/productimages/'

        parent = el.parent
        raise ArguemntError.new "unknown html" if parent.node_name != 'a'
        href = parent.get_attribute :href
        alt = el.get_attribute :alt

        src_id_regexp = /source.php\?id=(?<src_id>\d+)/
        m = src_id_regexp.match(href)

        metadata.source_id = m.captures[0]
        metadata.source_name = alt
        metadata.source_image = src
        return metadata
      end
      metadata
    end

    def read_thumbnail(doc, metadata)
      img_node = doc.css('img#b0:not(.vector)')[0]
      src = img_node.get_attribute :src
      metadata.thumbnail = src
      metadata
    end

    def read_image(doc, metadata)
      img_node_list = doc.css('img')
      img_node_list.each do |el|
        src = el.get_attribute :src
        unless src.include? 'ami.animecharactersdatabase.com'
          next
        end

        id_val = el.get_attribute :id
        next unless id_val.nil?

        invalid_text_array = [
          '/FLAGS/',
          '/emote/',
          '/forum/',
          '/img/hearts/',
          '/thumbs/',
          '/guild/',
          '/productimages/',
          '/bg/',
          '/48x48/',
          '/rss2.png',
          '/img/vote.png',
          '/hosted/Red2.png',
          '/PWA_Award.png',
        ]

        is_valid = true
        invalid_text_array.each do |text|
          if src.include?(text)
            is_valid = false
            break
          end
        end

        next unless is_valid

        raise ArgumentError.new "cannot find valid character image url" unless metadata.image.nil?
        metadata.image = src
      end
      metadata
    end

    def read_profile(doc, metadata)
      table = get_profile_table doc
      tr_list = table.css('tr')
      tr_list.each do |tr_node|
        th_node = tr_node.css('th')[0]
        td_node = tr_node.css('td')[0]

        key = filter_profile_key th_node.inner_text
        value = filter_profile_value td_node.inner_text
        #puts "#{key} = #{value}"

        # 실제로 서비스에서 사용할 확률이 높은 데이터
        required_cond_table = {
          character_id: 'character_id',
          romaji_name: 'name_en',
          japanese_name: 'name_jp',
          aliases: 'aliases',
          birthday: 'birthday',
        }

        # 데이터에 있을거라고 기대하지만 실제로 안쓸거같은 데이터
        predefined_cond_table = {
          role: 'role',
          tagged: 'tags',
          cv: 'cv',
          voice_actors: 'voice_actors',
          type: 'type',
          blood_type: 'blood_type',
          #height: 'height',
          #bust: 'bust',
          #waist: 'waist',
          #hip: 'hip',
        }

        if required_cond_table.include? key
          attr_name = required_cond_table[key]
          metadata.send("#{attr_name}=", value)

        elsif predefined_cond_table.include? key
          attr_name = predefined_cond_table[key]
          metadata.send("#{attr_name}=", value)

        else
          metadata.set_extra(key, value)
        end
      end
      metadata
    end
  end
end
