module Entities
  class TimeslotsForDay
    attr_reader :day, :timeslots

    def initialize(day)
      @day = day
      @timeslots = []
    end

    def add_timeslot(timeslot)
      @timeslots << timeslot
    end

    def self.convert_parking_rate(parking_rate)
      parking_rate.days.each do |day|
        Globals.daily_timeslots[day] <<
          parking_rate.timeslot
      end

      Globals.daily_timeslots
    end
  end
end
