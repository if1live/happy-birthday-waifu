class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :slug
      t.string :title_en
      t.string :title_jp
      t.string :title_romaji
      t.string :title_furigana
      t.integer :anime_db_id

      t.timestamps null: false
    end

    add_index :sources, :slug, unique: true
    add_index :sources, :anime_db_id, unique: true
  end
end
