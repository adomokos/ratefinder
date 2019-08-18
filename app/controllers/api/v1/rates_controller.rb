module Api
  module V1
    class RatesController < ApplicationController

      # POST /api/v1/rates/find
      def find
        post_attributes = params.require(:rate).permit(:start_time, :end_time)
        start_time = post_attributes.fetch(:start_time)
        end_time = post_attributes.fetch(:end_time)

        begin
          found_rate = Entities::RateFinder.find(start_time, end_time)
          render :json => found_rate, :status => :ok
        rescue Entities::TimesNotSameDayError
          render :nothing => true, :status => 204
        end
      end
    end
  end
end
