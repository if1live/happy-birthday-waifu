require 'anime-character-db-crawler'


WebMock.disable!

namespace :crawler do
  # rake + 인자를 넘길때는 "[]"를 이용
  # bundle exec rake "crawler:source[1693]"


  task :source, [:src_id] => [] do |t, args|
    # yosuga no sora = 1693
    src_id = args[:src_id]
    cmd = AnimeCharacterDB::SourceFetchCommand.new
    result = cmd.run src_id
    puts "Source[#{src_id.to_s}] #{result.data.create_slug} success"

    # character 별로 긁기
    result.data.characters.each do |x|
      download_character x.character_id
    end
  end

  task :character, [:character_id] => [] do |t, args|
    # kasugano sora = 13162
    character_id = args[:character_id]
    download_character character_id
  end

  def download_character(character_id)
    cmd = AnimeCharacterDB::CharacterFetchCommand.new
    result = cmd.run character_id
    puts "Character[#{character_id.to_s}] #{result.data.create_slug} success"
  end

  task :copy_thumbnail do
    src_path = Rails.root.join 'anime-character-db', 'character'
    dst_path = Rails.root.join 'public', 'static', 'thumb'

    entries = Dir.entries(src_path)
    entries = entries.reject { |x| ['.', '..'].include? x }
    entries.each do |src_dir|
      character_id = src_dir.split('-')[0]
      src_filepath = File.join src_path, src_dir, 'thumb.jpg'
      dst_filepath = File.join dst_path, "#{character_id}.jpg"
      FileUtils.copy src_filepath, dst_filepath
    end
  end
end
