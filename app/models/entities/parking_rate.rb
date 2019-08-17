module Entities
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
end
