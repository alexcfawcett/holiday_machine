class AbsencesController < ApplicationController

  before_filter :authenticate_user!

  # GET /vacations
  def index

    load_data
    @absence = current_user.absences.build
    @absence.holiday_year_id = HolidayYear.current_year.id

    respond_to do |format|
      format.js
      format.html
    end

  end

  # GET /vacations/1
  def show
    @absence = Absence.find_by_id(params[:id])
    if @absence.blank?
      redirect_to calendar_path
      return
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /vacations
  # POST /vacations.xml
  def create
    @absence = Absence.new(params[:absence])
    @absence.user = current_user
    @absence.holiday_status_id = 1

    if @absence.save
      manager_id = current_user.manager_id
      manager = User.find_by_id(manager_id)
      unless manager.nil?
        HolidayMailer.holiday_request(current_user, manager, @absence).deliver
      end

      flash[:success] = I18n.t('absence_created')
      redirect_to absences_path
    else
      load_data
      render 'index'
    end
  end

  def update
    #TODO temp - to bypass the validation around half-days
    ActiveRecord::Base.connection.execute("update absences set holiday_status_id = #{params[:absence][:holiday_status_id]} where id = #{params[:id]}")

    @absence = Absence.find_by_id(params[:id])
    vacation_user = @absence.user

    if vacation_user.manager_id
      manager = User.find_by_id(vacation_user.manager_id)
      #TODO prevent holiday status being switched to pending
      HolidayMailer.holiday_actioned(manager, @absence).deliver
    end

    respond_to do |format|
      flash[:notice] = "Status has been changed"
      format.js
    end

  end


  # DELETE /absences/1
  # DELETE /absences/1.xml
  def destroy
    @absence = Absence.find(params[:id])

    respond_to do |format|
      if @absence.destroy
        unless current_user.manager_id.nil?
          manager = User.find_by_id(@absence.user.manager_id)
          HolidayMailer.holiday_cancellation(current_user, manager, @absence).deliver
        end
        @days_remaining = current_user.get_holiday_allowance.days_remaining

        @row_id = params[:id]
        @failed = false
        
        @other_absence_count = current_user.absences.where('absence_type_id !=1').count
        @holiday_count = current_user.absences.where('absence_type_id =1').count
        
        flash.now[:success] = "Absence deleted"
        format.js
        
      else
        flash[:error] = "Could not delete an absence which has passed"
        @failed = true
        format.js
      end
    end
  end

  private
  def load_data
    # TODO: Add validation. Will fall down if invalid id is supplied
    if params[:holiday_year_id]
      holiday_year = HolidayYear.find(params[:holiday_year_id])
      @days_remaining = current_user.holidays_left(holiday_year)
      @holidays = Absence.user_holidays_in_year(current_user, holiday_year)
    else
      @days_remaining = current_user.holidays_left(HolidayYear.current_year)
      @holidays = Absence.user_holidays_in_year(current_user, HolidayYear.current_year)
    end

    # Not effected by year dropdown
    @active_team_holidays = Absence.active_team_holidays(current_user.manager_id)
    @upcoming_team_holidays = Absence.upcoming_team_holidays(current_user)

  end
end
