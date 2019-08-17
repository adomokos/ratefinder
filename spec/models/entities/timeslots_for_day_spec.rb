require 'no_rails_helper'
require 'json'

module Entities
  RSpec.describe TimeslotsForDay do
    before(:each) { Globals.reset }

    let(:parking_rates_source) do
      file = File.read('resources/parking_rates.json')
      result = JSON.parse(file, :symbolize_names => true)
      result.fetch(:rates)
    end
    let(:rate_hash) do
      { :days=>'mon,tues,thurs',
        :times=>'0900-2100',
        :tz=>'America/Chicago',
        :price=>1500
      }
    end

    it 'can pivot ParkingRate to DailyParkingRates' do
      parking_rate = ParkingRateParser.new(rate_hash).parse
      daily_timeslots = TimeslotsForDay.convert_parking_rate(parking_rate)

      timeslots = daily_timeslots.select { |_k, v| v.any? }
      expect(timeslots.length).to eq(3)
    end

    it 'can collect all Timeslots from the JSON file' do
      parking_rates = parking_rates_source.map do |prs|
        ParkingRateParser.new(prs).parse
      end

      parking_rates.each do |pr|
        TimeslotsForDay.convert_parking_rate(pr)
      end

      timeslots = Globals.daily_timeslots.select { |_k, v| v.empty? }

      expect(timeslots).to be_empty
    end
  end
end
