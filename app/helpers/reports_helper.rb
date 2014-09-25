require_relative '../../config/initializers/holiday_status_constants'
require_relative '../../config/initializers/absence_type_constants'
module ReportsHelper

	def user_holidays_taken user
		Absence.user_holidays(user.id).per_holiday_year(@current_year_id)
			.where(holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_TAKEN,
             absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY).sum(:working_days_used)
	end

	def user_holidays_pending user
		Absence.user_holidays(user.id).per_holiday_year(@current_year_id)
			.where(holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
             absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY).sum(:working_days_used)
	end

	def user_holidays_authorised user
		Absence.user_holidays(user.id).per_holiday_year(@current_year_id)
			.where(holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_APPROVED,
             absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY).sum(:working_days_used)
	end

	def user_holidays_unbooked user
		user.get_holiday_allowance.days_remaining
	end

end