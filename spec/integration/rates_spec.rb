require 'swagger_helper'

describe 'SpotHero Rates API' do

  path '/api/v1/rates/find' do

    post 'Finds a rate' do
      tags 'Rates'
      description 'Searches rates based on start time and end time'
      consumes 'application/json'
      produces 'application/json'
      parameter :name => :timeslot, :in => :body, :schema => {
        :type => :object,
        :properties => {
          :start_time => { type: :string },
          :end_time => { type: :string }
        },
        :required => [ 'start_time', 'end_time' ]
      }

      response '200', 'OK' do
         examples 'application/json' => {
            :result => 1750,
            :msg => nil
          }

        let(:timeslot) do
          { :start_time => '2015-07-01T07:00:00-05:00',
            :end_time => '2015-07-01T12:00:00-05:00' }
        end

        run_test! do |response|
          expected_response_body = {:result => 1750, :msg => nil}.to_json
          expect(response.body).to eq(expected_response_body)
        end
      end

      response '422', 'invalid user input' do
         examples 'application/json' => {
            :result => nil,
            :msg => 'Start time after end time'
          }

        let(:timeslot) do
          { :start_time => '2015-07-01T07:00:00-05:00',
            :end_time => '2015-07-02T12:00:00-05:00' }
        end
        run_test!
      end
    end
  end
end
