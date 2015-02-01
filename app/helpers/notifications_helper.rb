require 'twitter'
require 'setty'

module NotificationsHelper
  def create_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Settings.twitter_app_key
      config.consumer_secret = Settings.twitter_app_secret
      config.access_token = Settings.twitter_access_token
      config.access_token_secret = Settings.twitter_access_token_secret
    end
  end
end

class NotificationFactory
  include NotificationsHelper
end
