class UsersController < ApplicationController
  def show
    return render :status => 403 unless user_signed_in?

    character_q = current_user.character_list_q
    favorite_list = character_q.to_a
    favorite_list = favorite_list.sort { |a, b| a.date <=> b.date }

    @favorite_list = favorite_list
  end
end
