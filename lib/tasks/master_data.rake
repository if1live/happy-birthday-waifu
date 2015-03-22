require 'master-data'

namespace :master_data do
  "create db/seeds/*.yml"
  task :create => [:create_source, :create_character] do
  end

  task :create_source do
    puts "create source seed"
    MasterData::create_seed :source
  end

  task :create_character do
    puts "create character seed"
    MasterData::create_seed :character
  end
end
