require 'raven'

dsn_table = {
  production: 'https://49e7c5904dfa4e69b840af8279b36bae:202646e595ef4660b6acecc88caf311f@app.getsentry.com/39327'
}

Raven.configure do |config|
  dsn_url = dsn_table[Rails.env]
  unless dsn_url.nil?
    config.dsn = dsn_url
    puts "Use sentry : #{dsn_url}"
  end
end
