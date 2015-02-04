class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id, null: false
      t.integer :character_id, null: false
      t.integer :noti_year

      t.timestamps null: false
    end

    add_index :favorites, [:user_id, :character_id], unique: true
  end
end
