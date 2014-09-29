class UserDaysController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authenticate_manager

  # GET /user_days
  def index
    #The user viewing this is a manager and wants his own team
    @team_users = User.get_team_users(current_user.id)

    if params[:holiday_year_id]
      @selected_year = HolidayYear.find(params[:holiday_year_id])
     elsif flash[:holiday_year_id]
      @selected_year = HolidayYear.find(flash[:holiday_year_id])
    else
      @selected_year = HolidayYear.current_year
    end

    @user_day = UserDay.new

    respond_to do |format|
      format.js
      format.html
    end
  end

  # POST /user_days
  # POST /user_days.xml
  def create
    @user_day = UserDay.new(user_day_params)

    if params[:user_day][:holiday_year_id]
      @user_day.holiday_year = HolidayYear.find(params[:user_day][:holiday_year_id])
    else
      @user_day.holiday_year = HolidayYear.current_year
    end

    holiday_year_id = @user_day.holiday_year.id

    @user = @user_day.user
    @allowance = @user.get_holiday_allowance_for_selected_year(@user_day.holiday_year)
    @allowance.days_remaining += @user_day.no_days

    if @user_day.save and @allowance.save
      redirect_to user_days_url, flash: { success: I18n.t('user_day.update_success'), holiday_year_id: holiday_year_id }
    else
      redirect_to user_days_url, flash: { error: I18n.t('user_day.update_failure'), holiday_year_id: holiday_year_id }
    end
  end
  
  private
  
  def user_day_params
    params.require(:user_day).permit(:no_days, :user_id, :holiday_year_id, :reason)
  end

end
