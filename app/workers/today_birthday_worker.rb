class TodayBirthdayWorker
  include Sidekiq::Worker

  def perform(*args)
    main
  end

  def dummy()
    now = Time.new
    puts "Current Time : " + now.inspect
  end

  def main()
    today = Date.today
    puts "#{today.month}/#{today.day} birthday tweet"

    date_str = Character.date_to_s today.month, today.day
    today_q = Character.where(date: date_str)
    character_list = today_q.to_a

    factory = NotificationFactory.new
    client = factory.create_client

    character_list.each do |character|
      msg = "오늘은 #{character.name_ko}의 생일입니다."
      client.update msg
    end
  end
end
