require 'no_rails_helper'
require 'json'

module Entities
  RSpec.describe ParkingRate do
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

    it 'can be parsed from JSON' do
      parking_rate = ParkingRateParser.new(rate_hash).parse

      expect(parking_rate.days).to eq(%i(monday tuesday thursday))
      expect(parking_rate.start_time).to eq(HourMinute.new(9, 0))
      expect(parking_rate.end_time).to eq(HourMinute.new(21, 0))
      expect(parking_rate.timezone.to_s).to eq('America - Chicago')
      expect(parking_rate.price).to eq(1500)
    end

    it 'can be validated' do
      parking_rate = ParkingRate.new(
        {:days => nil,
         :start_time => nil,
         :end_time => nil,
         :timezone => nil,
         :price => nil})

      expect(parking_rate).not_to be_valid
      expect(parking_rate.errors.details.keys) \
        .to eq(%i(start_time end_time timezone price days))

      parking_rate.days = [:monday]
      expect(parking_rate).not_to be_valid
      expect(parking_rate.errors.details.keys) \
        .to eq(%i(start_time end_time timezone price))
    end
  end
end
