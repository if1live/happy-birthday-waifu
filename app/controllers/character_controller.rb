require 'date'

require 'setty'

class CharacterController < ApplicationController
  def index
    today = Date.today
    @month = (params.has_key? :month) ? params[:month].to_i : today.month
    @day = (params.has_key? :day) ? params[:day].to_i : today.day

    date_str = Character.date_to_s @month, @day

    # today
    today_q = Character.where(date: date_str)
    # today ~ year end
    curr_year_q = Character.where('date > ?', date_str).order(date: :asc)
    # year start ~ today
    next_year_q = Character.where('date < ?', date_str).order(date: :asc)

    @today_list = today_q.to_a
    @next_list = curr_year_q.to_a + next_year_q.to_a
    @all_character_list = @today_list + @next_list
    approach_count = 3
    @approach_list = @next_list[0...approach_count]

  end

  def date
    @month = params[:month].to_i
    @day = params[:day].to_i
    date_str = Character.date_to_s @month, @day

    character_q = Character.where(date: date_str)
    @character_list = character_q.to_a
  end

  def detail
    @slug = params[:slug]

    @character = Character.find_by slug: @slug
  end
end
