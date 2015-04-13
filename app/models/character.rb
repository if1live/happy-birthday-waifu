# coding: utf-8
# == Schema Information
#
# Table name: characters
#
#  id               :integer          not null, primary key
#  slug             :string
#  name_en          :string
#  name_ko          :string
#  name_jp          :string
#  year             :integer
#  date             :string(5)
#  external_url     :string           default("")
#  anime_db_id      :integer
#  anime_db_img_url :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  source_id        :integer
#


require 'date'

class Character < ActiveRecord::Base
  include CharactersHelper
  include FavoritesHelper

  rails_admin do
  end

  has_many :favorite

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


  def remain_days(date = nil)
    date = Date.today if date.nil?

    next_day = next_birthday date
    next_day.mjd - date.mjd
  end

  def d_day(date = nil)
    date = Date.today if date.nil?

    remain = remain_days date
    if remain == 0
      "D-Day"
    else
      "D-#{remain}"
    end
  end

  def anime_character_db_url
    "http://www.animecharactersdatabase.com/character.php?id=#{anime_db_id}"
  end
end
