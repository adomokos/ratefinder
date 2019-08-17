class HourMinute
  attr_reader :hour, :minute
  def initialize(hour, minute)
    @hour = hour
    @minute = minute
  end

  def ==(other)
    self.hour  == other.hour &&
    self.minute == other.minute
  end
end

class ParkingRate
  include ActiveModel::Model
  attr_accessor :days, :start_time, :end_time, :timezone, :price
end

class ParkingRateParser
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def parse
    days = parse_days
    start_time = parse_start_hour_minute
    end_time = parse_end_hour_minute

    ParkingRate.new(
      :days => days,
      :start_time => start_time,
      :end_time => end_time,
      :timezone => parse_time_zone,
      :price => parse_price)
  end

  def self.parse_day(date_string)
    Date.parse(date_string)
      .strftime("%A")
      .downcase
      .to_sym
  end

  private

  def parse_time_zone
    ActiveSupport::TimeZone.find_tzinfo(data.fetch(:tz))
  end

  def parse_price
    data.fetch(:price)
  end

  def parse_start_hour_minute
    time_data = data.fetch(:times)
    times = time_data.split('-')
    hour = times.first[0..1]
    minutes = times.first[2..4]
    HourMinute.new(hour.to_i, minutes.to_i)
  end

  def parse_end_hour_minute
    time_data = data.fetch(:times)
    times = time_data.split('-')
    hour = times.last[0..1]
    minutes = times.last[2..4]
    HourMinute.new(hour.to_i, minutes.to_i)
  end

  def parse_days
    days = data.fetch(:days).split(',')
    days.map {|d| parse_day(d) }
  end

  def parse_day(day)
    date_dict = {
      :sun => :sunday,
      :mon => :monday,
      :tues => :tuesday,
      :wed => :wednesday,
      :thurs => :thursday,
      :fri => :friday,
      :sat => :saturday
    }

    date_dict.fetch(day.to_sym)
  end
end
