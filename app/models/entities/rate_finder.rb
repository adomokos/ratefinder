module Entities
  class RateFinder
    def self.find(start_time_input, end_time_input)
      start_time = Time.parse(start_time_input)
      end_time = Time.parse(end_time_input)

      raise StartDateAfterEndDateError.new('Start time after end time') \
        if start_time >= end_time

      timeslots = timeslots_for_time(start_time)

      match = timeslots.find do |ts|
        overlapping_timestamp?(start_time, end_time, ts)
      end

      return match.price if match

      raise RateNotFoundError.new('No rate was found')
    end

    def self.timeslots_for_time(time)
      weekday = time.strftime("%A").downcase.to_sym
      Globals.daily_timeslots.fetch(weekday)
    end

    def self.overlapping_timestamp?(start_time, end_time, ts)
      ts_start_time = ts.create_start_time_with_zone(start_time)
      ts_end_time = ts.create_end_time_with_zone(end_time)

      start_time <= ts_end_time && ts_start_time <= end_time \
        && start_time >= ts_start_time && end_time <= ts_end_time
    end
  end
end
