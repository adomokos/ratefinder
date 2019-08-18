module Entities
  module Errors
    class StartDateAfterEndDateError < StandardError; end
    class TimesNotSameDayError < StandardError; end
  end
end
