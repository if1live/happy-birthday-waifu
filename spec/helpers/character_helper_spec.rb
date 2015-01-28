require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CharacterHelper. For example:
#
# describe CharacterHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
#RSpec.describe CharacterHelper, :type => :helper do
#  pending "add some examples to (or delete) #{__FILE__}"
#end

describe CharacterHelper do
  describe '#date_to_s' do
    it 'convert day/month to string' do
      month = 2
      day = 5
      actual = CharacterHelper.date_to_s month, day
      expected = '02/05'
      expect(actual).to eq(expected)
    end

    it 'invalid month/day' do
      expect(CharacterHelper.date_to_s 0, 1).to be_nil
      expect(CharacterHelper.date_to_s 13, 1).to be_nil

      expect(CharacterHelper.date_to_s 1, 32).to be_nil
      expect(CharacterHelper.date_to_s 1, 0).to be_nil
    end
  end

  describe '#str_to_date' do
    it 'convert string to monty/day' do
      actual = CharacterHelper.str_to_date '02/05'
      expected = {month: 2, day: 5}
      expect(actual).to be_eql(expected)
    end
  end
end
