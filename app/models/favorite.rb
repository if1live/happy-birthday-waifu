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

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :character

  def self.check(user, character)
    Favorite.where(
      user: user,
      character: character,
      ).first_or_create
  end

  def uncheck
    self.destroy
  end

  def self.checked?(user, character)
    Favorite.exists? user: user, character: character

  end
end
