module Entities
  class ParkingRate
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :days, :start_time, :end_time, :timezone, :price

    validates_presence_of :start_time, :end_time, :timezone, :price
    validates :days, length: { minimum: 1 }
  end
end
