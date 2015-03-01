require 'httpclient'
require 'yaml'
require 'open-uri'

module AnimeCharacterDB
  class SourceFetchCommand
    class Result
      attr_accessor :src_id,
                    :data,
                    :base_path,
                    :data_file,
                    :thumb_file

    end

    def self.create_url(src_id)
      "http://www.animecharactersdatabase.com/source.php?id=#{src_id}"
    end

    def run(src_id)
      parser = SourceHTMLParser.new
      client = HTTPClient.new

      url = SourceFetchCommand.create_url src_id
      r = client.get url
      raise ArgumentError.new "invalid HTTP status code #{r.status_code}" if r.status_code != 200
      html = r.content
      source_data = parser.read html

      dirname = "#{src_id.to_s}-#{source_data.create_slug}"
      base_path = Rails.root.join('anime-character-db', 'source', dirname)
      FileUtils.mkdir_p(base_path)

      data_filename = base_path.join('data.yml')
      File.write(data_filename, YAML.dump(source_data.to_hash))

      thumb_url = source_data.img_thumbnail
      thumb_filename = base_path.join("thumb#{File.extname(thumb_url).downcase}")

      open(thumb_filename, 'wb') do |file|
        file << open(thumb_url).read
      end

      result = Result.new
      result.src_id = src_id
      result.data = source_data
      result.base_path = base_path
      result.data_file = data_filename
      result.thumb_file = thumb_filename
      result
    end
  end

  class CharacterFetchCommand
    class Result
      attr_accessor :character_id,
                    :data,
                    :base_path,
                    :img_file,
                    :thumb_file,
                    :data_file
    end

    def self.create_url(character_id)
      "http://www.animecharactersdatabase.com/character.php?id=#{character_id}"
    end

    def run(character_id)
      parser = CharacterHTMLParser.new
      client = HTTPClient.new

      url = CharacterFetchCommand.create_url character_id
      r = client.get url
      raise ArgumentError.new "invalid HTTP status code #{r.status_code}" if r.status_code != 200
      html = r.content
      character_data = parser.read html

      dirname = "#{character_id.to_s}-#{character_data.create_slug}"
      base_path = Rails.root.join('anime-character-db', 'character', dirname)
      FileUtils.mkdir_p(base_path)

      # 어디에 데이터를 저장할 것인가?
      # json을 저장할 경우, 심볼이 문자열로 변환된다. 이를 막으려고 yaml 채택
      data_filename = base_path.join('data.yml')
      File.write(data_filename, YAML.dump(character_data.to_hash))

      # 관련된 이미지를 받아서 어디에 저장할 것인가?
      img_url = character_data.image
      thumb_url = character_data.thumbnail

      img_filename = base_path.join("img#{File.extname(img_url).downcase}")
      thumb_filename = base_path.join("thumb#{File.extname(thumb_url).downcase}")

      open(img_filename, 'wb') do |file|
        file << open(img_url).read
      end

      open(thumb_filename, 'wb') do |file|
        file << open(thumb_url).read
      end

      result = Result.new
      result.character_id = character_id
      result.data = character_data
      result.base_path = base_path
      result.data_file = data_filename
      result.img_file = img_filename
      result.thumb_file = thumb_filename
      result
    end
  end
end
