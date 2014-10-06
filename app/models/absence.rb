require_relative '../../config/initializers/holiday_status_constants'
require_relative '../../config/initializers/absence_type_constants'
class Absence < ActiveRecord::Base

  attr_accessible :date_from, :date_to, :description, :holiday_status_id, :user_id, :absence_type_id, :half_day_from, :half_day_to
  attr_accessor :half_day_from, :half_day_to

  HOL_COLOURS = %W{#FDF5D9 #D1EED1 #FDDFDE #DDF4Fb}
  BORDER_COLOURS = %W{#FCEEC1 #BFE7Bf #FBC7C6 #C6EDF9}

  # Associations
  belongs_to :holiday_status
  belongs_to :holiday_year
  belongs_to :user
  belongs_to :absence_type

  # Validation
  validates :date_from, :date_to, :description, :holiday_status_id, :user_id, :absence_type_id, presence: true
  validate :holiday_must_not_straddle_holiday_years
  validate :half_days_not_on_working_days, :on => :create
  validate :dont_exceed_days_remaining, :on => :create
  validate :date_from_must_be_before_date_to
  validate :working_days_greater_than_zero
  validate :no_overlapping_holidays, :on => :create

  # Callbacks
  before_validation :adjust_half_days
  before_save :set_half_days
  before_save :set_working_days
  after_create :decrease_days_remaining
  before_destroy :check_if_holiday_has_passed
  after_destroy :add_days_remaining

  # Scopes
  scope :user_holidays, lambda { |user_id| where(user_id: user_id).order('date_from ASC') }
  scope :per_holiday_year, lambda { |holiday_year_id| where(holiday_year_id: holiday_year_id) }

  scope :active, lambda { where("? BETWEEN date_from AND date_to",Absence.time_string)}
  scope :in_between, lambda { |from_date, to_date|  where "date_from >= ? and date_to <= ?", from_date, to_date}
  scope :upcoming, lambda { where("date_from BETWEEN ? AND ?", Absence.time_string, Absence.time_string(Time.zone.now + 1.weeks))}

  scope :team_holidays, lambda { |manager_id| where(user_id: User.get_team_users(manager_id))}
  scope :active_team_holidays, lambda { |manager_id| where(user_id: User.get_team_users(manager_id)).
                                        active.order('date_from ASC') }

  scope :upcoming_team_holidays, lambda { |manager_id| where(user_id: User.get_team_users(manager_id)).
                                          upcoming.order('date_from ASC') }

  scope :user_holidays_in_year, lambda { |user, holiday_year_id| where(holiday_year_id: holiday_year_id).
                                          where(user_id: user.id).order('date_from ASC')  }


  def date_from= val
    self[:date_from] = (convert_uk_date_to_iso val, true)
  end

  def date_to= val
    self[:date_to] = (convert_uk_date_to_iso val, false)
  end

  def self.as_json current_user, start_date, end_date, filter
    date_from = DateTime.parse(Time.at(start_date.to_i).to_s)
    date_to = DateTime.parse(Time.at(end_date.to_i).to_s)

    if filter == "ME"
      holidays = user_holidays(current_user.id).in_between(date_from, date_to)
    elsif filter == "TEAM"
      holidays = team_holidays(current_user.manager_id).in_between(date_from, date_to)
    else
      holidays = in_between(date_from, date_to)
    end

    bank_holidays = BankHoliday.in_between(date_from, date_to)
    self.convert_to_json holidays, bank_holidays, current_user
  end


  def self.mark_as_taken current_user
    holidays = self.where "date_to < ? and user_id =?", DateTime.now, current_user.id
    status_taken = HolidayStatus.find_by_status("Taken")
    status_authorised = HolidayStatus.find_by_status("Authorised")
    holidays.each do |hol|
      if hol.holiday_status == status_authorised
        exec_sql = ActiveRecord::Base.connection
        exec_sql.execute("UPDATE absences SET holiday_status_id = #{status_taken.id} WHERE absences.id = #{hol.id}")
      end
    end
  end

  private

  def self.select_user_group current_user, selection_type
    case selection_type
      when 'ALL'
        return User.all
      when 'ME'
        User.where(id: current_user.id)
      else
        # Doesn't work for managers (they see the team upwards)
        return User.get_team_users(current_user.manager_id)        
    end
  end

  def half_days_not_on_working_days
    return if date_from.nil?

   if date_on_non_working_day(date_from) && half_day_from != "Full Day"
     errors.add(:date_from, I18n.t('absence.half_day_on_non_working_day'))
     false
   elsif date_on_non_working_day(date_to) && half_day_to != "Full Day"
     errors.add(:date_to, I18n.t('absence.half_day_on_non_working_day'))
     false
   end
  end

  def check_if_holiday_has_passed
    if holiday_status_id == HolidayStatusConstants::HOLIDAY_STATUS_APPROVED ||
        holiday_status_id == HolidayStatusConstants::HOLIDAY_STATUS_TAKEN
      if date_to < Date.today
        errors.add(:base, I18n.t('absence.holiday_has_passed'))
        false
      end
    end
  end

  def self.convert_to_json(holidays, bank_holidays, current_user)
    json = []
    holidays.each do |hol|
      email = hol.user.email
      half_day_afternoon = hol.date_from.hour == 13 ? "Half Day PM" : ""
      half_day_morning = hol.date_to.hour == 12 ? "Half Day AM" : ""

      half_day = half_day_afternoon + half_day_morning
      unless half_day.blank?
        half_day = "\n"+half_day
      end

      if hol.user == current_user
        hol_hash = { id: hol.id, title: [hol.user.forename, hol.description].join(": ") + " " + half_day,
                     start: hol.date_from.iso8601,
                     end: hol.date_to.iso8601, color: HOL_COLOURS[hol.holiday_status_id - 1],
                     textColor: '#404040',
                     borderColor: BORDER_COLOURS[hol.holiday_status_id - 1],
                     type: 'holiday'}
      else
        hol_hash = { id: hol.id,
                     title: hol.user.full_name + " " + half_day,
                     start: hol.date_from.iso8601,
                     end: hol.date_to.iso8601,
                     color: HOL_COLOURS[hol.holiday_status_id - 1],
                     textColor: '#404040',
                     borderColor: BORDER_COLOURS[hol.holiday_status_id - 1]}
      end
      json << hol_hash
    end

    bank_holidays.each do |hol|
      hol_hash = { id: hol.id, title: hol.name, start: hol.date_of_hol.to_s, color: "black", type: 'bank-holiday'}
      json << hol_hash
    end
    json
  end

  def date_from_must_be_before_date_to
    return false if date_from.nil? || date_to.nil?
    errors.add(:date_from, I18n.t('absence.date_from_must_be_before_date_to')) if date_from > date_to
  end

  def working_days_greater_than_zero
    return false if date_from.nil? || date_to.nil?

    @working_days = business_days_between
    errors.add(:working_days_used, I18n.t('absence.request_uses_no_working_days')) if @working_days==0
  end

  def holiday_must_not_straddle_holiday_years
    number_years = HolidayYear.holiday_years_containing_holiday(date_from, date_to).count
    errors.add(:base, I18n.t('absence.holiday_request_crosses_years')) if number_years> 1
  end

  def no_overlapping_holidays
    absences = Absence.where(user_id: self.user_id)
    absences.each do |absence|
      errors.add(:base, I18n.t('absence.overlapping_holiday_request')) if overlaps?(absence)
    end
  end

  def overlaps?(absence)
    (date_from.to_date - absence.date_to.to_date) * (absence.date_from.to_date - date_to.to_date) >= 0
  end

  def convert_uk_date_to_iso date_str, is_date_from
    if date_str.length != 10
      errors.add(:date, I18n.t('invalid_date_format'))
      return nil
    end

    split_date=date_str.split("/")
    if is_date_from
      DateTime.new(split_date[2].to_i, split_date[1].to_i, split_date[0].to_i, 9)
    else
      DateTime.new(split_date[2].to_i, split_date[1].to_i, split_date[0].to_i, 17)
    end
  end

  def set_working_days
    self[:working_days_used] = @working_days

    unless self[:uuid]
      guid = UUID.new
      self[:uuid] = guid.generate
    end

    unless self[:holiday_year]
      self.holiday_year = HolidayYear.holiday_year_used(self[:date_from], self[:date_to]).first
    end
  end

  def business_days_between
    @half_day_adjustment ||=0
    bank_holidays = BankHoliday.in_between(date_from - 1.day, date_to + 1.day)
    holidays_array = bank_holidays.collect { |hol| hol.date_of_hol }
    weekdays = (date_from.to_date..date_to.to_date).reject { |d| [0, 6].include? d.wday or holidays_array.include?(d) }
    business_days = weekdays.length - @half_day_adjustment
    business_days
  end

  def decrease_days_remaining
    return unless self.absence_type_id == AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY
    holiday_allowance = self.user.get_holiday_allowance_for_dates self.date_from, self.date_to
    holiday_allowance.days_remaining -= business_days_between
    holiday_allowance.save
  end

  # Adds days back when deleting leave
  def add_days_remaining
    holiday_allowance.days_remaining += self.working_days_used
    return unless self.absence_type_id == AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY
    holiday_allowance = self.user.get_holiday_allowance_for_dates self.date_from, self.date_to
    holiday_allowance.days_remaining += business_days_between
    holiday_allowance.save
  end

  def dont_exceed_days_remaining
    if user.nil?
      errors.add(:user_id, I18n.t('is_invalid'))
      return
    end

    return unless self.absence_type_id == AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY
    holiday_allowance = self.user.get_holiday_allowance_for_dates self.date_from, self.date_to
    if holiday_allowance == 0 or holiday_allowance.nil? then
      return
    end
    errors.add(:working_days_used, I18n.t('absence.request_exceeds_allowance')) if holiday_allowance.days_remaining < business_days_between
  end

  def set_half_days
    if date_from.to_date == date_to.to_date
      #Ensure the half days match
      if (half_day_from != half_day_to) # && (half_day_from != "Full Day" || half_day_to != "Full Day")
        errors.add(:base, I18n.t('absence.select_same_type_of_half_day'))
        return false
      else
        if half_day_from == "Half Day AM"
          #E.g 2011-01-01 09:00 to 2011-01-01 12:00
          write_attribute(:date_to, DateTime.new(date_to.year, date_to.month, date_to.day, 12))
        elsif half_day_from == "Half Day PM"
          #E.g 2011-01-01 13:00 to 2011-01-01 17:00
          write_attribute(:date_from, DateTime.new(date_to.year, date_to.month, date_to.day, 13))
        end
      end
    else
      if half_day_from != "Full Day" && half_day_from != "Half Day PM"
        errors.add(:base, I18n.t('absence.holiday_can_only_begin_with_half_day_in_the_afternoon'))
        return false
      elsif half_day_to != "Full Day" && half_day_to != "Half Day AM"
        errors.add(:base, I18n.t('absence.holiday_cannot_end_with_half_day_in_the_afternoon'))
        return false
      else
        if half_day_from == "Half Day PM"
          #e.g 2011-01-01 13:00
          write_attribute(:date_from, DateTime.new(date_from.year, date_from.month, date_from.day, 13))
        end
        if half_day_to == "Half Day AM"
          #e.g 2011-05-01 12:00
          write_attribute(:date_to, DateTime.new(date_to.year, date_to.month, date_to.day, 12))
        end
      end
    end
  end

  def adjust_half_days
    @half_day_adjustment = 0.0
    if self.date_from.to_date == self.date_to.to_date
      if half_day_from == half_day_to && half_day_from.include?('Half')
        @half_day_adjustment = 0.5
      end
    else
      if half_day_from != half_day_to
        if half_day_from.include?('Half') && half_day_to.include?('Half')
          @half_day_adjustment = 1
        elsif half_day_from.include?('Half') || half_day_to.include?('Half')
          @half_day_adjustment = 0.5
        end
      end
    end
    @half_day_adjustment
  end

  def date_on_non_working_day date_to_check
    return true if date_to_check.wday == 6 or date_to_check.wday == 0
    bank_holidays = BankHoliday.all
    return bank_holidays.collect{|hol| hol.date_of_hol}.include?(date_to_check.to_date)
  end
  
  def self.time_string(time_obj=nil)
    time_obj ||= Time.zone.now
    time_obj.strftime('%Y-%m-%d %H:%M:%S')
  end
end
