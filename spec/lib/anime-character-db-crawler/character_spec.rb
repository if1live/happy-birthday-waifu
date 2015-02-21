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

describe AnimeCharacterDB::CharacterData do
  let(:subject) { AnimeCharacterDB::CharacterData.new }
  describe '#birthday=' do
    it 'success' do
      subject.birthday = 'February 5'
      expect(subject.birthday).to eq('02/05')
    end
  end

  describe '#name_jp=' do
    it 'kanji + hirakana' do
      subject.name_jp = '春日野 穹 （かすがの そら）'
      expect(subject.name_kanji).to eq('春日野 穹')
      expect(subject.name_kana).to eq('かすがの そら')
    end

    it 'katakana' do
      name = 'イリーナ・ウラジーミロヴナ・プチナ'
      subject.name_jp = name
      expect(subject.name_kanji).to be_nil
      expect(subject.name_kana).to eq(name)
    end

    it 'kanji' do
      name = '山川 美千子'
      subject.name_jp = name
      expect(subject.name_kanji).to eq(name)
      expect(subject.name_kana).to be_nil
    end
  end
end

describe AnimeCharacterDB::CharacterHTMLParser do
  let(:kasugano_sora_filepath) { get_filepath 'character-13162-kasugano-sora.html' }
  let(:kasugano_sora_html) { File.read kasugano_sora_filepath }

  let(:ibuki_shirakusa_filepath) { get_filepath 'character-62894-ibuki-shirakusa.html' }
  let(:ibuki_shirakusa_html) { File.read ibuki_shirakusa_filepath }

  let(:parser) { AnimeCharacterDB::CharacterHTMLParser.new }

  describe '#read' do
    it 'kasugano sora' do
      data = parser.read kasugano_sora_html

      # required
      expect(data.character_id).to be(13162)
      expect(data.name_en).to eq('Sora Kasugano')
      expect(data.name_jp).to eq('春日野 穹 （かすがの そら）')
      expect(data.aliases).to be_nil
      expect(data.birthday).to eq('02/05')

      # predefined
      expect(data.role).to eq('Main Character')
      expect(data.tags).to eq(['loli', 'ribbon', 'lolita', 'hair ribbons', 'dress', 'doll'])
      expect(data.cv).to eq('白波遥')
      expect(data.voice_actors).to eq(['Hiroko Taguchi', '田口宏子', 'たぐち ひろこ'])
      expect(data.type).to eq('Normal')
      expect(data.blood_type).to eq('O')

      # extra
      expect(data.extra[:height]).to eq('152cm')

      # image
      thumbnail = 'http://ami.animecharactersdatabase.com/./images/yosuganosora/Sora_Kasugano_thumb.jpg'
      expect(data.thumbnail).to eq(thumbnail)

      image = 'http://ami.animecharactersdatabase.com/./images/yosuganosora/Sora_Kasugano.png'
      expect(data.image).to eq(image)
    end

    it 'ibuki shirakursa' do
      data = parser.read ibuki_shirakusa_html
      # required
      expect(data.character_id).to eq(62894)
      expect(data.name_en).to eq('Ibuki Shirakusa')
      expect(data.name_jp).to eq('白草 いぶき （しらくさ いぶき）')
      expect(data.aliases).to be_nil
      expect(data.birthday).to be_nil

      # predefined
      expect(data.role).to eq('Unsorted')
      expect(data.tags).to eq(['v bangs', 'ribbon', 'stockings', 'wavy hair', 'school uniform', 'hairband', 'twin'])
      expect(data.cv).to eq('藤咲ウサ')
      expect(data.type).to eq('Normal')

      # extra
      expect(data.extra[:height]).to eq('152cm')
      expect(data.extra[:bust]).to eq('79cm')
      expect(data.extra[:waist]).to eq('57cm')
      expect(data.extra[:hip]).to eq('83cm')

      # image
      thumbnail = 'http://ami.animecharactersdatabase.com/uploads/chars/thumbs/200/11498-135469648.jpg'
      expect(data.thumbnail).to eq(thumbnail)

      image = 'http://ami.animecharactersdatabase.com/uploads/chars/11498-1811138177.jpg'
      expect(data.image).to eq(image)
    end
  end

  describe '#filter_profile_key' do
    it 'Birthday (more)' do
      key = 'Birthday (more)'
      actual = parser.filter_profile_key key
      expect(actual).to eq(:birthday)
    end

    it 'Blood Type' do
      key = 'Blood Type'
      actual = parser.filter_profile_key key
      expect(actual).to eq(:blood_type)
    end
  end
end
