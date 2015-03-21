schedule_file = "config/schedule.yml"

if File.exists?(schedule_file)
  hash = YAML.load_file schedule_file
  if hash != false
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end
