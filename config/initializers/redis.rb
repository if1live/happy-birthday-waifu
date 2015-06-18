uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/" )
Rails.logger.info uri
p uri
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
