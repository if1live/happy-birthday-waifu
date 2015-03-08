class AddSourceIdToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :source_id, :integer

    add_index :characters, :source_id
  end
end
