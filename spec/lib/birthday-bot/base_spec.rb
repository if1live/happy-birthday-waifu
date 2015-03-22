require 'spec_helper'
require 'rails_helper'
require 'birthday-bot'

describe BirthdayBot::TwitterSender do
  let(:subject) { BirthdayBot::TwitterSender.create 'a', 's', true }
  let(:character) do
    Character.new do |c|
      c.id = 123
      c.name_en = 'Sora Kasugano'
      c.name_ko = '카스가노 소라'
      c.name_jp = '春日野 穹 （かすがの そら）'
      c.date = '02/05'
    end
  end

  describe '#filter_message' do
    it 'run' do
      msg = '（）'
      actual = subject.filter_message msg
      expect(actual).to eq('()')
    end
  end

  describe '#url' do
    it 'run' do
      expected = "http://birthday.libsora.so/characters/1"
      expect(subject.url 1).to eq(expected)
    end
  end

  describe '#create_message' do
    it 'run' do
      msg = subject.create_message character
    end
  end
end
