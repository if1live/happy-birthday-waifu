require 'birthday-bot'


class ManageController < ApplicationController
  username = Rails.application.secrets.user
  password = Rails.application.secrets.password
  http_basic_authenticate_with name: username, password: password

  before_action :set_twitter_token
  before_action :set_basic_variables

  def set_basic_variables
    @debug_mode = debug_mode?
  end

  def debug_mode?
    if params.include? :debug
      if ['on', 'true'].include? params[:debug]
        true
      else
        false
      end
    else
      false
    end
  end

  def set_twitter_token
    if debug_mode?
      dev_user = User.find_by screen_name: 'if1live_dev'
      unless dev_user.nil?
        @access_token = dev_user.token
        @secret_token = dev_user.secret
      end
    else
      @access_token = ENV['TWITTER_ACCESS_TOKEN']
      @secret_token = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def index
    system_today_str = sprintf("%02d/%02d", Date.today.month, Date.today.day)

    if params.include? :date
      m = /\d\d\/\d\d/.match params[:date]
      if m.nil?
        @today_str = system_today_str
      else
        @today_str = params[:date]
      end
    else
      @today_str = system_today_str
    end

    @character_list = Character.where(date: @today_str).all.to_a
  end

  def tweet_character_birthday
    character_id = params[:character_id]
    character = Character.find character_id

    bot = BirthdayBot::TwitterSender.create @access_token, @secret_token, debug_mode?
    tweet = bot.tweet_character_birthday character
    render json: { ok: true, url: tweet.uri.to_s }
  end
end
