module MasterData
  SEED_ROOT = Rails.root.join 'db', 'seeds'
  ANIME_CHARACTER_DB_ROOT = Rails.root.join 'anime-character-db'
  SOURCE_ROOT = ANIME_CHARACTER_DB_ROOT.join 'source'
  CHARACTER_ROOT = ANIME_CHARACTER_DB_ROOT.join 'character'
end
