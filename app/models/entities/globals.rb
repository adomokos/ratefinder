module Entities
  class Globals
    def self.daily_timeslots
      @@daily_timeslots ||= initial_hash
    end

    def self.reset
      @@daily_timeslots = initial_hash
    end

    def self.load_data
      file = File.read('resources/parking_rates.json')
      parsed_data = JSON.parse(file, :symbolize_names => true)
      rates_data = parsed_data.fetch(:rates)

      parking_rates = rates_data.map do |prs|
        ParkingRateParser.new(prs).parse
      end

      parking_rates.each do |pr|
        TimeslotsForDay.convert_parking_rate(pr)
      end
    end

    def self.initial_hash
      Date::DAYNAMES.each_with_object({}) do |d, acc|
        acc[d.downcase.to_sym] = []
      end
    end
    private_class_method :initial_hash
  end
end
