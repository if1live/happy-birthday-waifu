require 'rails_helper'
require 'factories/character'
require 'date'

describe Character do
  let(:character) { FactoryGirl.build(:character) }

  describe '#birthday_to_s' do
    let(:with_year_character) { FactoryGirl.build(:with_year_character) }

    it 'without year' do
      expect(character.birthday_to_s).to be == "2월 5일"
    end

    it 'with year' do
      expect(with_year_character.birthday_to_s).to be == "2008년 2월 5일"
    end
  end

  describe "#remain_days" do
    it 'today' do
      remain = character.remain_days Date.new(2015, 2, 5)
      expect(remain).to be(0)
    end

    it 'tomorrow' do
      remain = character.remain_days Date.new(2015, 2, 5-1)
      expect(remain).to be(1)
    end

    it 'yesterday = next year' do
      remain = character.remain_days Date.new(2015, 2, 5+1)
      expect(remain).to be(365-1)
    end
  end

  describe "#birthday" do
    it 'get' do
      year = Date.today.year
      expect(character.birthday year).to eql(Date.new(year, 2, 5))
    end
  end
end
