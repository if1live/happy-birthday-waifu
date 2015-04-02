require 'sidekiq'
require 'sidekiq/web'

# http://stackoverflow.com/questions/12265421/sidekiq-authentication
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [Rails.application.secrets.user, Rails.application.secrets.password]
end


schedule_file = "config/schedule.yml"

if File.exists?(schedule_file)
  hash = YAML.load_file schedule_file
  if hash != false
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end
