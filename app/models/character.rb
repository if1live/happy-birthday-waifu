# coding: utf-8

require 'date'

class Character < ActiveRecord::Base
  include CharacterHelper

  rails_admin do
  end

  validates :slug, uniqueness: true
  validates :date, length: { is: 5 }
  validates :date, format: { with: /\d\d\/\d\d/ }

  def month
    extract_month_from_str date
  end

  def day
    extract_day_from_str date
  end

  def birthday_to_s
    if year
      "#{year}년 #{month}월 #{day}일"
    else
      "#{month}월 #{day}일"
    end
  end

  def birthday year
    Date.new(year, month, day)
  end

  def curr_birthday
    birthday Date.today.year
  end

  def next_birthday today
    curr_year = today.year
    curr_year_birthday = birthday curr_year
    next_year_birthday = birthday curr_year + 1

    if curr_year_birthday < today
      return next_year_birthday
    else
      return curr_year_birthday
    end
  end


  def remain_days today
    next_day = next_birthday today
    next_day.mjd - today.mjd
  end

  def d_day
    today = Date.today
    remain = remain_days today
    if remain == 0
      "D-Day"
    else
      "D-#{remain}"
    end
  end

  def remain_days_from_today
    remain_days Date.today
  end
end
