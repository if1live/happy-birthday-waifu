require 'date'

class CharactersController < ApplicationController
  before_action :assign_month_day

  def assign_month_day
    today = Date.today
    @month = (params.has_key? :month) ? params[:month].to_i : today.month
    @day = (params.has_key? :day) ? params[:day].to_i : today.day

    return render :status => 403 if @month < 1
    return render :status => 403 if @month > 12
    return render :status => 403 if @day < 1
    return render :status => 403 if @day > 31

    today_date = Date.new today.year, @month, @day
    tomorrow_date = today_date + 1
    @tomorrow_month = tomorrow_date.month
    @tomorrow_day = tomorrow_date.day

    @today = today_date
    @tomorrow = tomorrow_date
  end

  def date
    @character_list = get_today_character_list @month, @day
  end

  def list
    today_str = Character.date_to_s @month, @day

    # today ~ year end
    curr_year_q = Character.where('date >= ?', today_str).order(date: :asc)
    # year start ~ today
    next_year_q = Character.where('date < ?', today_str).order(date: :asc)
    curr_year_list = curr_year_q.to_a
    next_year_list = next_year_q.to_a
    @all_list = curr_year_list + next_year_list

    # TODO 월별로 정렬하기. 남은것과 지난것을 따로 처리하기
    @month_table = {}
    (@month...(@month + 13)).each do |m|
      @month_table[m] = []
    end
    curr_year_list.each do |character|
      month = character.month
      @month_table[month] << character
    end
    next_year_list.each do |character|
      month = character.month + 12
      @month_table[month] << character
    end
    @month_table = @month_table.select { |k, v| v.length > 0 }
  end

  def detail
    @character = Character.find_by(id: params[:character_id])
    return render :status => 404 if @character.nil?

    favorite_user_q = @character.user_list_q
    @favorite_count = favorite_user_q.count

    if user_signed_in?
      @favorite = Favorite.find_by(user: current_user, character: @character)
    else
      @favorite = nil
    end
  end

  def index
    @today_list = get_today_character_list @month, @day
    @tomorrow_list = get_today_character_list @tomorrow_month, @tomorrow_day

    @next_list = get_next_character_list
    approach_count = 3
    @approach_list = @next_list[0...approach_count]
  end

  def get_today_character_list(month, day)
    date_str = Character.date_to_s month, day
    today_q = Character.where(date: date_str)
    today_list = today_q.to_a
  end

  def get_next_character_list
    today_str = Character.date_to_s @month, @day
    tomorrow_str = Character.date_to_s @tomorrow_month, @tomorrow_day

    # tomorrow ~ year end
    curr_year_q = Character.where('date > ?', tomorrow_str).order(date: :asc)
    # year start ~ today
    next_year_q = Character.where('date < ?', today_str).order(date: :asc)
    next_list = curr_year_q.to_a + next_year_q.to_a
  end
end
