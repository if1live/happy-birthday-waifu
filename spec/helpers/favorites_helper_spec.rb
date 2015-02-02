require 'rails_helper'

RSpec.describe FavoritesHelper, :type => :helper do
  let(:character) { FactoryGirl.create(:character) }
  let(:character_a) { FactoryGirl.create(:yesterday_character) }
  let(:user) { FactoryGirl.create(:user) }
  let(:user_a) { FactoryGirl.create(:user_a) }

  describe '#character_list_q' do
    it 'empty' do
      q = user.character_list_q
      expect(q.count).to be(0)
    end

    it 'exist' do
      Favorite.check user, character
      q = user.character_list_q
      actual = q.to_a
      expect(actual.length).to be(1)
      expect(actual).to eq([character])
    end

    it 'character cannot use this function' do
      expect(character.character_list_q).to be_nil
    end
  end

  describe '#user_list_q' do
    it 'empty' do
      q = character.user_list_q
      expect(q.count).to be(0)
    end

    it 'exist' do
      Favorite.check user, character
      q = character.user_list_q
      actual = q.to_a
      expect(actual.length).to be(1)
      expect(actual).to eq([user])
    end

    it 'user cannot use this function' do
      expect(user.user_list_q).to be_nil
    end
  end
end
