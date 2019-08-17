module Entities
  class Globals
    def self.daily_timeslots
      @@daily_timeslots ||= initial_hash
    end

    def self.reset
      @@daily_timeslots = initial_hash
    end

    def self.initial_hash
      Date::DAYNAMES.each_with_object({}) do |d, acc|
        acc[d.downcase.to_sym] = []
      end
    end
    private_class_method :initial_hash
  end
end
