module Entities
  module Errors
    class RateNotFoundError < StandardError; end
    class StartDateAfterEndDateError < StandardError; end
    class TimesNotSameDayError < StandardError; end
  end
end
