module FavoritesHelper
  def character_list_q
    return if self.kind_of? Character
    Character.joins(:favorite).where({ favorites: {user_id: self} })
  end

  def user_list_q
    return if self.kind_of? User
    User.joins(:favorite).where('favorites.character_id = ?', self)
  end
end
