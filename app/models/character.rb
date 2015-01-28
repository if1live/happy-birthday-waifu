# coding: utf-8

require 'date'

class Character < ActiveRecord::Base
  rails_admin do
  end

  def month
    date[0...2].to_i
  end

  def day
    date[3...5].to_i
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
end
