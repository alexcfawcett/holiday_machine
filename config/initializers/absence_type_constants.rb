class AbsenceTypeConstants
  # Constants to be used throughout the codebase. If the DB value changes, then this MUST be changed.
  # Set with ||= operator as in rspec I was receiving a lot of already initialized constant messages.
  ABSENCE_TYPE_HOLIDAY ||= 1
  ABSENCE_TYPE_ILLNESS ||= 2
  ABSENCE_TYPE_MATERNITY_PATERNITY ||= 3
  ABSENCE_TYPE_FAMILY ||= 4
  ABSENCE_TYPE_OTHER ||= 5
end