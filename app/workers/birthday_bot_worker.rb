require 'date'

class BirthdayBotWorker
  include Sidekiq::Worker

  def perform(*args)
    access_token = ENV['TWITTER_ACCESS_TOKEN']
    secret_token = ENV['TWITTER_ACCESS_TOKEN_SECRET']

    bot = BirthdayBot::TwitterSender.create access_token, secret_token, false

    date = Date.today
    today_str = Character.date_to_s date.month, date.day
    characters = Character.where(date: today_str)
    characters.each do |character|
      tweet = bot.tweet_character_birthday character
      retval = { ok: true, url: tweet.uri.to_s }
      puts retval
    end
  end
end

class HealthCheckWorker
  include Sidekiq::Worker

  def perform(*args)
    msg = "Health Check : #{Time.now}"

    logger.info msg
    puts msg
  end
end
