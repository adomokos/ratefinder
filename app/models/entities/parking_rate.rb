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

  class ParkingRate
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :days, :timeslot

    def initialize(days:, start_time:, end_time:, timezone:, price:)
      @days = days
      @timeslot = Timeslot.new(start_time, end_time, timezone, price)
    end

    delegate :start_time, :end_time, :timezone, :price, to: :timeslot

    validates_presence_of :start_time, :end_time, :timezone, :price
    validates :days, length: { minimum: 1 }
  end

  class Timeslot
    attr_reader :start_time, :end_time, :timezone, :price

    def initialize(start_time, end_time, timezone, price)
      @start_time = start_time
      @end_time = end_time
      @timezone = timezone
      @price = price
    end
  end

  class ToTimeslotsForDay
    def self.convert(parking_rate)
      parking_rate.days.each do |day|
        Globals.daily_timeslots[day] <<
          parking_rate.timeslot
      end

      Globals.daily_timeslots
    end
  end

  class TimeslotsForDay
    attr_reader :day, :timeslots

    def initialize(day)
      @day = day
      @timeslots = []
    end

    def add_timeslot(timeslot)
      @timeslots << timeslot
    end
  end
end
