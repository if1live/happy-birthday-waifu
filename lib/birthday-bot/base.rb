require 'open-uri'
require 'twitter'

module BirthdayBot
  class TwitterSender
    attr_reader :client_key, :secret_key
    attr_reader :access_token, :secret_token

    def initialize(access_token, secret_token)
      @client_key = ENV['TWITTER_APP_KEY']
      @secret_key = ENV['TWITTER_APP_SECRET']
      raise ArgumentError.new "client key is empty" if @client_key.nil?
      raise ArgumentError.new "secret key is empty" if @secret_key.nil?

      if access_token.nil? || access_token.length == 0
        raise ArgumentError.new "empty access token"
      end
      if secret_token.nil? || secret_token.length == 0
        raise ArgumentError.new "empty secret token"
      end

      @access_token = access_token.strip
      @secret_token = secret_token.strip

      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = @client_key
        config.consumer_secret     = @secret_key
        config.access_token        = @access_token
        config.access_token_secret = @secret_token
      end
    end

    def self.create(access_token, secret_token, debug = false)
      if debug
        FakeTwitterSender.new access_token, secret_token
      else
        RealTwitterSender.new access_token, secret_token
      end
    end

    def url(character_id)
      "http://birthday.libsora.so/characters/#{character_id}"
    end

    def filter_message(msg)
      # 사용하지 않기로 한 텍스트 제거
      char_table = [
        ['（', '('],
        ['）', ')'],
        ['　', ' ']
      ]
      char_table.each do |before, after|
        msg = msg.gsub before, after
      end
      msg
    end

    def create_message(character)
      msg = "#{character.birthday_to_s}은 #{character.name_ko}(#{character.name_jp}, #{character.name_en}) 생일입니다. #{url character.id}"
      msg = filter_message msg
      msg
    end

    def tweet_character_birthday(character)
      if character.anime_db_img_url.nil?
        tweet_text_birthday character
      else
        tweet_media_birthday character
      end
    end

  end


  class FakeTwitterSender < TwitterSender
    attr_reader :called_method

    def initialize(access_token, secret_token)
      super access_token, secret_token
      @called_method = nil
    end
    def tweet_text_birthday(character)
      @called_method = :tweet_text_birthday
    end
    def tweet_media_birthday(character)
      @called_method = :tweet_media_birthday
    end
  end

  class RealTwitterSender < TwitterSender
    def tweet_text_birthday(character)
      message = create_message character
      @client.update message
    end

    def tweet_media_birthday(character)
      message = create_message character
      # 이미지를 다운받았다가 첨부하기
      filepath = "/tmp/birthday-bot.png"
      open(filepath, 'wb') do |file|
        file << open(character.anime_db_img_url).read
      end

      @client.update_with_media message, File.new(filepath)
    end
  end
end
