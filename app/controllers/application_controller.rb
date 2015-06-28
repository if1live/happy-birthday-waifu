class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :assign_month_day

  def assign_month_day
    today = Date.today

    @year = (params.has_key? :year) ? params[:year].to_i : today.year
    @month = (params.has_key? :month) ? params[:month].to_i : today.month
    @day = (params.has_key? :day) ? params[:day].to_i : today.day

    return render :status => 403 if @month < 1
    return render :status => 403 if @month > 12
    return render :status => 403 if @day < 1
    return render :status => 403 if @day > 31

    @today_date = Date.new @year, @month, @day
    @tomorrow_date = @today_date + 1
    @yesterday_date = @today_date - 1

    @tomorrow_year = @tomorrow_date.year
    @tomorrow_month = @tomorrow_date.month
    @tomorrow_day = @tomorrow_date.day

    @yesterday_year = @yesterday_date.year
    @yesterday_month = @yesterday_date.month
    @yesterday_day = @yesterday_date.day

    date_fmt = "%Y-%m-%d"
    @today_str = @today_date.strftime date_fmt
    @tomorrow_str = @tomorrow_date.strftime date_fmt
    @yesterday_str = @yesterday_date.strftime date_fmt
  end
end
