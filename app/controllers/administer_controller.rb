require_relative '../../config/initializers/holiday_status_constants'
class AdministerController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authenticate_manager

  def index
    #TODO restrict holidays by year
    @statuses = HolidayStatus.all
    @users = User.get_team_users(current_user.id).includes(:absences).
        where('absences.holiday_year_id = ? AND absences.holiday_status_id = ?',
              HolidayYear.current_year.id, HolidayStatusConstants::HOLIDAY_STATUS_PENDING)
    respond_to do |format|
      format.html
    end
  end

end
