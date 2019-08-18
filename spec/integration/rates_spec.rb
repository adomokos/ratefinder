require 'swagger_helper'

describe 'SpotHero Rates API' do

  path '/api/v1/rates/find' do

    post 'Finds a rate' do
      tags 'Rates'
      consumes 'application/json'
      parameter name: :timeslot, in: :body, schema: {
        type: :object,
        properties: {
          start_time: { type: :string },
          end_time: { type: :string }
        },
        required: [ 'start_time', 'end_time' ]
      }

      response '200', 'rate found' do
        let(:timeslot) do
          { start_time: '2015-07-01T07:00:00-05:00',
            end_time: '2015-07-01T12:00:00-05:00' }
        end
        run_test!
      end
    end
  end
end
