require 'rails_helper'

RSpec.describe CharactersHelper, :type => :helper do
  let(:dummy_class) { Class.new { include CharactersHelper } }
  let(:subject) { dummy_class.new }

  describe '#date_to_s' do
    it 'convert day/month to string' do
      month = 2
      day = 5
      actual = dummy_class.date_to_s month, day
      expected = '02/05'
      expect(actual).to eq(expected)
    end

    it 'invalid month/day' do
      expect(dummy_class.date_to_s 0, 1).to be_nil
      expect(dummy_class.date_to_s 13, 1).to be_nil

      expect(dummy_class.date_to_s 1, 32).to be_nil
      expect(dummy_class.date_to_s 1, 0).to be_nil
    end
  end

  describe '#str_to_date' do
    it 'convert string to monty/day' do
      actual = subject.str_to_date '02/05'
      expected = {month: 2, day: 5}
      expect(actual).to be_eql(expected)
    end
  end
end
