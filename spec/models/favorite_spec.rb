# == Schema Information
#
# Table name: favorites
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  character_id :integer          not null
#  noti_year    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

require 'factories/user'

RSpec.describe Favorite, :type => :model do
  let(:character_a) { FactoryGirl.create(:character) }
  let(:character_b) { FactoryGirl.create(:yesterday_character) }

  let(:user_a) { FactoryGirl.create(:user) }
  let(:user_b) { FactoryGirl.create(:user_a) }

  describe '#check' do
    it 'success' do
      favorite = Favorite.check user_a, character_a
      expect(favorite).not_to be_nil
    end

    it 'not allow duplicate' do
      favorite_1 = Favorite.check user_a, character_a
      favorite_2 = Favorite.check user_a, character_a
      expect(favorite_1).to eq(favorite_2)

      expect(Favorite.count).to be(1)
    end

    it 'normal use' do
      favorite_1 = Favorite.check user_a, character_a
      favorite_2 = Favorite.check user_b, character_a
      favotire_3 = Favorite.check user_a, character_b
      favorite_4 = Favorite.check user_b, character_b

      expect(Favorite.count).to be(4)
    end
  end

  describe '#uncheck' do
    it 'uncheck exist' do
      favorite = Favorite.check user_a, character_a
      favorite.uncheck

      expect(Favorite.count).to be(0)
    end
  end
end
