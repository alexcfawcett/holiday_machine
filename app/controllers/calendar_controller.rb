class CalendarController < ApplicationController

  before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.js {
        #Populate the calendar
        holidays_json = Absence.team_holidays_as_json current_user, params[:start], params[:end], params[:filter]
        render :json => holidays_json
      }
      format.html {
        @holiday_status = HolidayStatus.order(:status)
        render 'show'
      }
    end
  end
end
