require 'nokogiri'

module AnimeCharacterDB
=begin
=end

  class CharacterMetadata
    attr_accessor :character_id,
                  :name_en,
                  :name_jp,
                  :aliases,
                  :role,
                  :tags,
                  :cv,
                  :voice_actors,
                  :type,
                  :height,
                  :blood_type,
                  :birthday
    def character_id=(val)
      @character_id = val.to_i
    end

    def tags=(val)
      if val.is_a? String
        @tags = val.split ', '
      else
        @tags = val
      end
    end

    def voice_actors=(val)
      if val.is_a? String
        @voice_actors = val.split ', '
      else
        @voice_actors = val
      end
    end
  end

  class CharacterHTMLParser
    def initialize()
      @doc = nil
    end

    def get_profile_table(doc)
      h3_list = doc.css('h3')
      h3_list.each do |elem|
        if elem.inner_text == 'Profile'
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


    def read html
      doc = Nokogiri::HTML.parse(html) do |config|
        config.options = Nokogiri::XML::ParseOptions::NOBLANKS
      end

      metadata = CharacterMetadata.new

      table = get_profile_table doc
      tr_list = table.css('tr')
      tr_list.each do |tr_node|
        th_node = tr_node.css('th')[0]
        td_node = tr_node.css('td')[0]

        key = th_node.inner_text.strip
        value = td_node.inner_text.strip
        #puts "#{key} = #{value}"

        cond_table = {
          'Character ID' => 'character_id',
          'Romaji Name' => 'name_en',
          'Japanese Name' => 'name_jp',
          'Aliases' => 'aliases',
          'Role' => 'role',
          'Tagged' => 'tags',
          'CV' => 'cv',
          'Voice Actors' => 'voice_actors',
          'Type' => 'type',
          'Height' => 'height',
          'Blood Type' => 'blood_type',
          'Birthday (more)' => 'birthday',
        }

        attr_name = cond_table[key]
        metadata.send("#{attr_name}=", value)
      end
      metadata
    end
  end
end
