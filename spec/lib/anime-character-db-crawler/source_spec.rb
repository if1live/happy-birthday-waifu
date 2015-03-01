require 'anime-character-db-crawler'

def get_filepath(filename)
  html_dir = File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    'testdata',
    'animecharacterdatabase')
  file_path = File.join(html_dir, filename)
  return file_path
end


describe AnimeCharacterDB::SourceData do
  let(:subject) { AnimeCharacterDB::SourceData.new }
  describe '#to_hash-#from_hash' do
    it 'success' do
      subject.src_id = '1693'
      subject.title_en = 'Yosuga no Sora'
      subject.title_jp = 'ヨスガノソラ'

      data = subject.to_hash
      dst = AnimeCharacterDB::SourceData.new
      dst.from_hash data
      expect(subject).to eq(dst)
      #p data
    end
  end

  describe '#create_slug' do
    it 'success' do
      subject.title_en = 'Yosuga no Sora'
      expect(subject.create_slug).to eq('yosuga-no-sora')
    end
  end
end

describe AnimeCharacterDB::SourceHTMLParser do
  let(:yosuga_no_sora_filepath) { get_filepath 'source-1693-yosuga-no-sora.html' }
  let(:yosuga_no_sora_html) { File.read yosuga_no_sora_filepath }
  let(:cocoro_function_filepath) { get_filepath 'source-103704-cocoro-function.html' }
  let(:cocoro_function_html) { File.read cocoro_function_filepath }

  let(:subject) { AnimeCharacterDB::SourceHTMLParser.new }

  describe '#read' do
    it 'yosuga no sora' do
      data = subject.read yosuga_no_sora_html
      # required
      expect(data.src_id).to eq(1693)
      expect(data.title_en).to eq('Yosuga no Sora')
      expect(data.title_jp).to eq('ヨスガノソラ')
      expect(data.title_romaji).to eq('Yosuga no Sora')
      expect(data.title_furigana).to eq('よすがのそら')
      expect(data.aliases).to eq([])

      # optional
      expect(data.studio_jp).to eq('スフィア')
      expect(data.studio_en).to eq('Sphere')
      expect(data.content_rating).to eq('A - Adult')
      expect(data.genre_tags).to eq(['incest', 'harem', 'lolicon', 'romantic comedy'])
      expect(data.release_date).to eq(Date.new 2008, 12, 05)

      # thumbnail
      img_thumbnail = "http://ami.animecharactersdatabase.com/productimages/1693.jpg"
      expect(data.img_thumbnail).to eq(img_thumbnail)

      # character
      expected_characters = [
        AnimeCharacterDB::SimpleCharacterData.new(13156, 'Haruka Kasugano'),
        AnimeCharacterDB::SimpleCharacterData.new(13155, 'Akira Amatsume'),
        AnimeCharacterDB::SimpleCharacterData.new(13157, 'Kazuha Migiwa'),
        AnimeCharacterDB::SimpleCharacterData.new(13159, 'Motoka Nogisaka'),
        AnimeCharacterDB::SimpleCharacterData.new(13160, 'Nao Yorihime'),
        AnimeCharacterDB::SimpleCharacterData.new(13162, 'Sora Kasugano'),
        AnimeCharacterDB::SimpleCharacterData.new(13158, 'Kozue Kuranaga'),
        AnimeCharacterDB::SimpleCharacterData.new(13161, 'Ryouhei Nakazato'),
        AnimeCharacterDB::SimpleCharacterData.new(13163, 'Yahiro Ifukube'),
      ]
      expect(data.characters).to eq(expected_characters)
    end

    it 'cocoro function' do
      data = subject.read cocoro_function_html
      # required
      expect(data.src_id).to eq(103704)
      expect(data.title_en).to eq('Cocoro@Function!')
      expect(data.title_jp).to eq('ココロ＠ファンクション !')
      expect(data.title_romaji).to eq('Kokoro@Function!')
      expect(data.title_furigana).to eq('ココロ＠ファンクション !')
      expect(data.aliases).to eq([])
      # optional
      expect(data.studio_jp).to eq('ぷるとっぷ')
      expect(data.studio_en).to eq('PULLTOP')
      expect(data.content_rating).to eq('A - Adult')
      expect(data.genre_tags).to eq([])
      expect(data.release_date).to eq(Date.new 2013, 9, 27)

      # thumbnail
      img_thumbnail = "http://ami.animecharactersdatabase.com/productimages/u/11498-932367893.jpg"
      expect(data.img_thumbnail).to eq(img_thumbnail)

      # character
    end
  end
end
