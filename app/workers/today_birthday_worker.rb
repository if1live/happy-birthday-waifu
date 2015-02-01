class TodayBirthdayWorker
  include Sidekiq::Worker

  def perform(*args)
    now = Time.new
    puts "Current Time : " + now.inspect
  end
end
