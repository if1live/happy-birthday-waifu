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
  files = files_for
  files.each do |fixture_file|
    hash_list = YAML.load_file(fixture_file)

    data_list = []
    hash_list.each do |key, value|
      data_list << value
    end

    Character.create data_list
  end
end

main
