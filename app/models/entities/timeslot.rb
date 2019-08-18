module Entities
  class Timeslot
    attr_reader :start_time, :end_time, :timezone, :price

    def initialize(start_time, end_time, timezone, price)
      @start_time = start_time
      @end_time = end_time
      @timezone = timezone
      @price = price
    end

    def create_start_time_with_zone(from_time)
      Time.new(from_time.year, from_time.month, from_time.day,
               start_time.hour, start_time.minute, 0, timezone)
    end

    def create_end_time_with_zone(from_time)
      Time.new(from_time.year, from_time.month, from_time.day,
               end_time.hour, end_time.minute, 0, timezone)
    end
  end
end
