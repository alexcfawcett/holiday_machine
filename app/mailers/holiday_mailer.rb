require_relative '../../config/initializers/holiday_status_constants'
class HolidayMailer < ActionMailer::Base

  def holiday_request(user, manager, holiday)
    @holiday = holiday
    @user = user
    @manager = manager
    @holiday = holiday
    @clashing_users_array = holiday_clash_with
    @url  = "http://example.com/validate_holiday"
    mail(to: @manager.email, from: @user.email,
         subject: "You have a holiday request awaiting")
  end

   def holiday_amendment(user, manager, holiday)
    @holiday = holiday
    @user = user
    @manager = manager
    @holiday = holiday
    @url  = "http://example.com/validate_holiday"
    mail(to: @manager.email, from: @user.email,
         subject: "You have a holiday change awaiting")
  end

  #TODO add status for holidays of used - these cannot be changed!!

  def holiday_cancellation(user, manager, holiday)
    @holiday = holiday
    @user = user
    @manager = manager
    mail(to: @manager.email, from: @user.email,
         subject: "This user has cancelled a holiday")
  end

  def holiday_actioned(manager, holiday)
    @holiday = holiday
    @user = @holiday.user
    @manager = manager
    subject = if holiday.holiday_status_id == HolidayStatusConstants::HOLIDAY_STATUS_APPROVED
                "Your holiday has been accepted"
              elsif holiday.holiday_status_id == HolidayStatusConstants::HOLIDAY_STATUS_REJECTED
                "Your holiday request has been rejected"
              end
    mail(to: @user.email, from: @user.email,
         subject: subject)
  end

  def holiday_clash_with 
    array = Array.new
    userAbsence = Absence.find_by_user_id(@user.id)
    User.get_team_users(@user.manager_id).each do |u|
      u.absences.each do |ab|
       if userAbsence.date_from <= ab.date_to && ab.date_from <= userAbsence.date_to
         array << u unless u.id == @user.id
        end
      end
    end 
    return array
  end
end
