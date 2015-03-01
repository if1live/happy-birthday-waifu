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
end
