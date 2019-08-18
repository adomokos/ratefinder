require 'no_rails_helper'
require 'json'

module Entities
  RSpec.describe RateFinder do
    before(:each) { Globals.reset; Globals.load_data }

    it 'can find the rate for start and end time' do
      start_time = '2015-07-01T07:00:00-05:00'
      end_time = '2015-07-01T12:00:00-05:00'

      result = RateFinder.find(start_time, end_time)

      expect(result).to eq(1750)
    end

    it 'can find the rate for another start and end time' do
      start_time = '2015-07-04T15:00:00+00:00'
      end_time = '2015-07-04T20:00:00+00:00'

      result = RateFinder.find(start_time, end_time)

      expect(result).to eq(2000)
    end

    it 'finds rate when start and end time is on timeslot boundaries' do
      start_time = '2015-07-04T09:00:00-05:00'
      end_time = '2015-07-04T21:00:00-05:00'

      result = RateFinder.find(start_time, end_time)

      expect(result).to eq(2000)
    end

    it 'does not find rate with different timezone' do
      start_time = '2015-07-04T09:00:00-04:00'
      end_time = '2015-07-04T21:00:00-04:00'

      result = RateFinder.find(start_time, end_time)

      expect(result).to be_nil
    end

    it 'returns nil when no rate was found' do
      start_time = '2015-07-04T07:00:00+05:00'
      end_time = '2015-07-04T20:00:00+05:00'

      result = RateFinder.find(start_time, end_time)
      expect(result).to be_nil
    end

    it 'throws InvalidDatesError when start date is after end date' do
      start_time = '2015-07-04T21:00:00+05:00'
      end_time = '2015-07-04T20:00:00+05:00'

      expect { RateFinder.find(start_time, end_time) } \
        .to raise_error(Errors::StartDateAfterEndDateError)
    end

    it 'throws TimesNotSameDayError when start date is after end date' do
      start_time = '2015-07-04T20:00:00+05:00'
      end_time = '2015-07-05T01:00:00+05:00'

      expect { RateFinder.find(start_time, end_time) } \
        .to raise_error(Errors::TimesNotSameDayError)
    end
  end
end
