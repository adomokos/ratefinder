module Entities
  class Timeslot
    attr_reader :start_time, :end_time, :timezone, :price

    def initialize(start_time, end_time, timezone, price)
      @start_time = start_time
      @end_time = end_time
      @timezone = timezone
      @price = price
    end
  end
end
