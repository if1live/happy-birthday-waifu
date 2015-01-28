class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :slug
      t.string :name_en
      t.string :name_ko

      # 대부분의 캐릭터는 year가 필요없다
      # 특별한 예외를 고려해서 남겨둔다
      t.integer :year, :null => true

      # 캐릭터의 생일은 month, day만 필요하다.
      # 이를 각각 고유한 필드에 저장하는 경우
      # 검색, 정렬이 귀찮은 관계로 하나의 필드에 합쳐서 저장
      # 규격은 'MM/DD'
      t.string :date, :limit => 5

      t.string :external_url, :default => ""

      t.timestamps null: false
    end

    add_index :characters, :slug, unique: true
    add_index :characters, :date
  end
end
