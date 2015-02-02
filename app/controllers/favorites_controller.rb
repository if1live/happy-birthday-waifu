class FavoritesController < ApplicationController
  before_action :assign_character

  def assign_character
    @character_id = (params.has_key? :character_id) ? params[:character_id].to_i : -1
    @character = Character.find @character_id
  end

  def toggle
    prev_checked = Favorite.checked? current_user, @character
    if prev_checked
      favorite = Favorite.check current_user, @character
      favorite.uncheck
    else
      favorite = Favorite.check current_user, @character
    end
    redirect_to :back
  end
end
