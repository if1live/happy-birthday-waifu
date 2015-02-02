class UsersController < ApplicationController
  def show
    character_q = current_user.character_list_q
    favorite_list = character_q.to_a
    favorite_list = favorite_list.sort { |a, b| a.date <=> b.date }

    @favorite_list = favorite_list
  end
end
