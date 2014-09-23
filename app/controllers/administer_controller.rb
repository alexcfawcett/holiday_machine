class AdministerController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authenticate_manager

  def index
    #TODO restrict holidays by year
    @statuses = HolidayStatus.all
    @users = User.get_team_users(current_user.id).includes(:absences).where('absences.holiday_year_id = ? AND absences.holiday_status_id = 1', HolidayYear.current_year.id)
    respond_to do |format|
      format.html
    end
  end

end
