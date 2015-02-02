require 'date'

class CharactersController < ApplicationController
  before_action :assign_month_day

  def assign_month_day
    today = Date.today
    @month = (params.has_key? :month) ? params[:month].to_i : today.month
    @day = (params.has_key? :day) ? params[:day].to_i : today.day

    render :status => 403 if @month < 1
    render :status => 403 if @month > 12
    render :status => 403 if @day < 1
    render :status => 403 if @day > 31

  end

  def date
    @character_list = get_today_character_list @month, @day
  end

  def list
    today_list = get_today_character_list @month, @day
    next_list = get_next_character_list @month, @day
    @all_list = today_list + next_list
  end

  def detail
    @slug = params[:slug]
    @character = Character.find_by slug: @slug
    render :status => 404 if @character.nil?

    favorite_user_q = @character.user_list_q
    @favorite_count = favorite_user_q.count
    @favorite = Favorite.find_by(user: current_user, character: @character)
  end

  def index
    @today_list = get_today_character_list @month, @day
    @next_list = get_next_character_list @month, @day
    approach_count = 3
    @approach_list = @next_list[0...approach_count]
  end

  def get_today_character_list(month, day)
    date_str = Character.date_to_s month, day
    today_q = Character.where(date: date_str)
    today_list = today_q.to_a
  end

  def get_next_character_list(month, day)
    date_str = Character.date_to_s month, day
    # today ~ year end
    curr_year_q = Character.where('date > ?', date_str).order(date: :asc)
    # year start ~ today
    next_year_q = Character.where('date < ?', date_str).order(date: :asc)
    next_list = curr_year_q.to_a + next_year_q.to_a
  end
end
