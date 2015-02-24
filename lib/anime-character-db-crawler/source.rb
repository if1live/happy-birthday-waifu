require 'nokogiri'

module AnimeCharacterDB
  class SourceData < BaseData
    # required
    attr_accessor :src_id,
                  :name_en,
                  :aliases,
                  :title_romaji,
                  :title_furigana,
                  :title_japanese

    attr_accessor :studio_jp,
                  :studio_en,
                  :content_rating,
                  :genre_tags,
                  :release_date,
                  :link

    def src_id=(val)
      @src_id = val.to_i
    end

    def genre_tags=(val)
      @genre_tags = filter_to_array val
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
      data
    end

    def read_basic_info(doc, data)

    end
  end
end
