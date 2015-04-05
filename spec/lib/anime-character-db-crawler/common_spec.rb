require 'rails_helper'
require 'anime-character-db-crawler'

describe AnimeCharacterDB::BaseData do
  let(:subject) { AnimeCharacterDB::BaseData.new }

  describe '#TODO' do
  end

  describe '#integer_attr_accessor' do
    let(:dummy_class) do
      class DummyClass < AnimeCharacterDB::BaseData
        integer_attr_accessor :foo
      end
      DummyClass
    end
    let(:subject) { dummy_class.new }

    it 'success' do
      subject.foo = '123'
      expect(subject.foo).to eq(123)
    end
  end

  describe '#tags_attr_accessor' do
    let(:dummy_class) do
      class DummyClass < AnimeCharacterDB::BaseData
        tags_attr_accessor :foo
      end
      DummyClass
    end
    let(:subject) { dummy_class.new }

    it 'empty' do
      subject.foo = ''
      expect(subject.foo).to eq([])
    end

    it 'normal' do
      subject.foo = 'a, b, c'
      expect(subject.foo).to eq(['a', 'b', 'c'])
    end
  end

  describe '#create_slug' do
    it 'simple' do
      expect(subject.convert_slug 'Yosuga no Sora').to eq('yosuga-no-sora')
    end
    it 'simple-1' do
      name = 'Nyarlathotep / Nyaruko'
      expect(subject.convert_slug name).to eq('nyarlathotep-nyaruko')
    end

    it 'special character' do
      expect(subject.convert_slug 'Haiyoru! Nyaruani').to eq('haiyoru-nyaruani')
    end

    it 'special character-1' do
      name = 'Osananajimi wa Daitouryou ~My girlfriend is the President.~'
      expected = 'osananajimi-wa-daitouryou-my-girlfriend-is-the-president'
      expect(subject.convert_slug name).to eq(expected)
    end
    it 'special character-2' do
      name = "Wezekieru 'Eru'"
      expect(subject.convert_slug name).to eq("wezekieru-eru")
    end

    it 'special character-3' do
      expect(subject.convert_slug 'Weremiya (Remi)').to eq('weremiya-remi')
    end

    it 'special character-4' do
      name = 'Saekano: How to Raise a Boring Girlfriend'
      expected = 'saekano-how-to-raise-a-boring-girlfriend'
      expect(subject.convert_slug name).to eq(expected)
    end

    it 'remove group' do
      name = 'Haiyore! Nyaruko-san (Series) (Franchise)'
      expect(subject.convert_slug name).to eq('haiyore-nyaruko-san')
    end
  end
end
