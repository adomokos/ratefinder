module Api
  module V1
    class RateFindResult
      include ActiveModel::Model
      attr_accessor :result, :msg
    end

    class RatesController < ApplicationController

      # POST /api/v1/rates/find
      def find
        post_attributes = params.require(:rate).permit(:start_time, :end_time)
        start_time = post_attributes.fetch(:start_time)
        end_time = post_attributes.fetch(:end_time)

        begin
          found_rate = Entities::RateFinder.find(start_time, end_time)
          result = RateFindResult.new(:result => found_rate, :msg => nil)

          render :json => result, :status => :ok

        rescue Entities::Errors::TimesNotSameDayError => err
          result = RateFindResult.new(:result => nil, :msg => err.message)
          render :json => result.to_json, :status => 422
        rescue Entities::Errors::StartDateAfterEndDateError => err
          result = RateFindResult.new(:result => nil, :msg => err.message)
          render :json => result.to_json, :status => 422
        end
      end

    end
  end
end
