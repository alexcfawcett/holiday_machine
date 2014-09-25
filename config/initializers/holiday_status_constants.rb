class HolidayStatusConstants
  # Constants to be used throughout the codebase. If the DB value changes, then this MUST be changed.
  # Set with ||= operator as in rspec I was receiving a lot of already initialized constant messages.
  HOLIDAY_STATUS_PENDING ||= 1
  HOLIDAY_STATUS_APPROVED ||= 2
  HOLIDAY_STATUS_REJECTED ||= 3
  HOLIDAY_STATUS_TAKEN ||= 4
end