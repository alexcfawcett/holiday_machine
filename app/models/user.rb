class User < ActiveRecord::Base

  devise :invitable, :database_authenticatable, :confirmable, :lockable, :recoverable,
    :registerable, :trackable, :timeoutable, :validatable

  ## Callbacks
  before_update :add_inviting_manager
  before_save :ensure_authentication_token
  after_create :create_allowance
  #after_destroy :delete_all_allowances

  ## Associations
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  has_many :employees, class_name: 'User', foreign_key: "manager_id" do
    def active_only
      where('confirmed_at NOT NULL')
    end
  end

  belongs_to :user_type
  has_many :user_days, dependent: :destroy
  has_many :absences, dependent: :destroy
  has_many :user_days_for_years, dependent: :destroy

  ## Validations
  validates_presence_of :forename, :surname, :user_type
  validates_presence_of :invite_code, on: :create
  validates_each :invite_code, on: :create do |record, attr, value|
    record.errors.add attr, "incorrect invite code" unless value && value == "Sage1nvite00"
  end
  validate :validate_not_own_manager, :validate_password_strength

  attr_accessor :invite_code
  attr_accessible :email, :password, :password_confirmation, :forename, :surname, :user_type_id, :manager_id, :invite_code, :invitation_token, :remember_me

  ## Scopes
  #Includes self if manager
  scope :get_team_users, lambda { |manager_id| where(
        '(users.manager_id = ? or users.id = ?) AND confirmed_at NOT NULL',
        manager_id,
        manager_id
    )}
  #Active managers only
  scope :active_managers, ->{where('confirmed_at NOT NULL AND user_type_id = 2')}

  ## Instance methods
  def full_name
    self[:forename] + " " + self[:surname]
  end

  def holidays_left year
    user_days_for_years.find_by_holiday_year_id(year.id).days_remaining
  end


  def get_holiday_allowance_for_dates date_from, date_to
    holiday_year = HolidayYear.where('date_start<=? and date_end>=?', date_from, date_to).first
    unless holiday_year.nil? #If a holiday isn't in a year( maybe straddles year) then returns nil
      allowance = UserDaysForYear.where("user_id = ? and holiday_year_id = ?", self.id, holiday_year.id).first
    end
    allowance
  end

  def get_holiday_allowance_for_selected_year year
    UserDaysForYear.where("user_id = ? and holiday_year_id = ?", self.id,year.id).first
  end

  # Change (or remove) this to use above method
  def get_holiday_allowance #For current year
    today = Date.today
    holiday_year = HolidayYear.where('date_start<=? and date_end>=?', today, today).first
    allowance = UserDaysForYear.where("user_id = ? and holiday_year_id = ?", self.id, holiday_year.id).first
    allowance
  end

  def create_allowance
    base_holiday_allowance = 25

    holiday_years = HolidayYear.all
    holiday_years.each do |year|
      UserDaysForYear.create(user_id: self.id, holiday_year_id: year.id, days_remaining: base_holiday_allowance)
    end
  end

  def user_days_for_selected_year year
    UserDay.where(:user_id => self.id, :holiday_year_id => year.id)
  end

  def add_inviting_manager
    unless invited_by_id.blank?
      self.manager_id = self.invited_by_id
      self.invited_by_id = nil
    end
  end

  def all_staff
    all = []
    self.employees.active_only.each do |user|
      all << user
      root_children = user.all_staff.flatten
      all << root_children unless root_children.empty?
    end
    return all.flatten
  end


  # Safe Token Authentication
  # https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def is_manager?
    return true if user_type_id == 2
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end

def validate_not_own_manager
  if manager_id != nil && id == manager_id
    errors.add(:manager_id, 'cannot be self')
  end
end

def validate_password_strength
  if password.present? and not password.match(/^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$/)
    errors.add(:password, 'Password must be at least 8 characters long, contain at least one lower case letter, one upper case letter,
    one digit + one special character. Valid special characters are: @, #, $, %, ^, &, +, = ')
  end
end