require 'spec_helper'
require 'anime-character-db-crawler'

describe AnimeCharacterDB::BirthdayHelper do
  let(:subject) { AnimeCharacterDB::BirthdayHelper.new }
  describe '#parse_date' do
    it 'February 5' do
      actual = subject.parse_date 'February 5'
      expect(actual).to eq('02/05')
    end
    it 'february 5' do
      actual = subject.parse_date 'february 5'
      expect(actual).to eq('02/05')
    end
    it 'Feb 5' do
      actual = subject.parse_date'Feb 5'
      expect(actual).to eq('02/05')
    end
    it 'feb 5' do
      actual = subject.parse_date 'feb 5'
      expect(actual).to eq('02/05')
    end
    it '02/05' do
      actual = subject.parse_date '02/05'
      expect(actual).to eq('02/05')
    end
    it 'nil' do
      expect(subject.parse_date nil).to be_nil
    end
    it 'empty string' do
      expect(subject.parse_date '').to be_nil
    end
    it 'not string' do
      expect(subject.parse_date 1234).to be_nil
    end
    it 'unknown format' do
      expect { subject.parse_date '0205' }.to raise_error
      expect { subject.parse_date 'fab 5' }.to raise_error
      expect { subject.parse_date 'fabruary 5' }.to raise_error
    end
  end
end
