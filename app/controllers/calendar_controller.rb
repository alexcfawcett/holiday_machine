class CalendarController < ApplicationController

  before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.js {
        #Populate the calendar
        #puts "FILTER: #{params[:filter]}"
        holidays_json = Absence.as_json current_user, params[:start], params[:end], params[:filter]
        render :json => holidays_json
      }
      format.html {
        @holiday_status = HolidayStatus.order(:status)
        render 'show'
      }
    end
  end

  def show
    @holiday_status = HolidayStatus.order(:status)
  end
end
