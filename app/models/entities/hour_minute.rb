module Entities
  class HourMinute
    attr_reader :hour, :minute
    def initialize(hour, minute)
      @hour = hour
      @minute = minute
    end

    def ==(other)
      self.hour  == other.hour &&
      self.minute == other.minute
    end
  end
end
