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
describe AnimeCharacterDB::CharacterHTMLParser do
  let(:filepath) { get_filepath 'character-13162-kasugano-sora.html' }
  let(:html) { File.read filepath }
  let(:parser) { AnimeCharacterDB::CharacterHTMLParser.new }
  describe '#read' do
    it 'success' do
      data = parser.read html
      expect(data.character_id).to be(13162)
      expect(data.name_en).to eq('Sora Kasugano')
      expect(data.name_jp).to eq('春日野 穹 （かすがの そら）')
      expect(data.aliases).to eq('')
      expect(data.role).to eq('Main Character')
      expect(data.tags).to eq(['loli', 'ribbon', 'lolita', 'hair ribbons', 'dress', 'doll'])
      expect(data.cv).to eq('白波遥')
      expect(data.voice_actors).to eq(['Hiroko Taguchi', '田口宏子', 'たぐち ひろこ'])
      expect(data.type).to eq('Normal')
      expect(data.height).to eq('152cm')
      expect(data.blood_type).to eq('O')
      expect(data.birthday).to eq('February 5')
    end
  end
end
