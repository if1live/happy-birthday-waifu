# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'yaml'

SEED_PATH = File.join(File.dirname(__FILE__), 'seeds')

def files_for
  Dir.glob(File.join(SEED_PATH, '*.{yml,csv}'))
end

def main
  klass_table = {
    characters: Character,
    sources: Source,
  }

  files = files_for
  files.each do |fixture_file|
    table_name = (File.basename fixture_file, '.yml').to_sym
    klass = klass_table[table_name]

    seed_list = YAML.load_file(fixture_file)

    # 시드데이터는 2종류이다
    # 하나는 기존에 저장된 데이터의 값을 바꾸는 경우
    # 다른 하나는 새로운 데이터를 저장하는 경우이다
    # 각각의 경우에 따라 다르게 대응해야 primary key=unique 를 처리 가능
    prev_id_list = klass.pluck(:id)
    new_data_list = []
    update_data_list = []

    seed_list.each do |key, value|
      if prev_id_list.include? value['id']
        update_data_list << value
      else
        new_data_list << value
      end
    end

    klass.create new_data_list

    update_data_list.each do |data|
      dirty = false
      record = klass.find data['id']
      data.each do |key, value|
        prev = record.send("#{key}")
        if prev != value
          record.send("#{key}=", value)
          dirty = true
        end
      end

      if dirty
        record.touch
        record.save!
      end
    end
  end
end

main
