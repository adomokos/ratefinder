# Ratefinder

Finding a Rate with Ruby - delivered with Rails.

You can run this app locally or on Docker, please run `make` in the project root dir to find out more about the menu options.

As of this writing, the following menu options are available:

```
% make
console                        Jump into the Rails console and interact with the services
docker-hop-on                  Jump on the docker instance
docker-remove-container        Stops and removes the container
docker-run-container           Run the container (one right now)
docker-run-tests               Run the tests in the container
docker-setup                   Sets up the app using Docker and Docker Compose
generate-swagger-doc           Generate Swagger documentation
run-example-no-result          Run an example that finds a rate
run-example                    Run an example that finds a rate
run                            Run the Rails app with an example JSON file locally
test                           Run the tests
```

### Setting it up locally

The app needs Ruby 2.6.3 with bundler installed. Run `bundle install` in the project root directory, that will install all the necessary gems into the `vendor/bundle` directory.
Run the app with `make run`, navigate to http://localhost:3000 and you should see the Swagger documentation.

![Swagger Documentation](https://raw.githubusercontent.com/adomokos/ratefinder/master/resources/images/swagger_documentation.jpg)

### Setting it up with Docker

Use the `make docker-setup` command to build the image from the provided Dockerfile and to create the instance. Once it's completed, navigate to http://localhost:3000 with your browser, that will redirect your request to the Swagger generated API documentation.

## About the Application

The application business logic is in [app/models/entities](app/models/entities) directory. The tests to exercise the logic is in the corresponding [spec dir](spec/models/entities).

The [JSON rates](resources/parking_rates.json) are parsed into [ParkingRate](app/models/entities/parking_rate.rb) objects. These objects are pivoted to [TimeslotsForDay](app/models/entities/timeslots_for_day.rb) entities when the app [is loaded](config/initializers/load_rates.rb) and stored in the [Globals](app/models/entities/globals.rb) class. The [RateFinder](https://github.com/adomokos/ratefinder/blob/master/app/models/entities/rate_finder.rb) class is responsible finding the rate for the provided start time and end time.

The application was developed as a console app, it can be extract into a different component if needed, Ruby on Rails was used as an API layer to [deliver](app/controllers/api/v1/rates_controller.rb) this functionality over http.

I don't have an endpoint to reload the rates from JSON on the fly. The user has to alter the [JSON rates](resources/parking_rates.json) locally, and restart the Rails process to load the updated configuration values into memory.

The Swagger documentation is generated from integration tests. Right now there is [only one](spec/integration/rates_spec.rb), to exercise the `rates/find POST` endpoint. The `make generate-swagger-doc` makefile target can regenerate the documentation [JSON file](swagger/v1/swagger.json).

## Running examples

You can run examples against the API using the Swagger tool. Another easy option is to use curl. I included two examples, one for a match and one for no match, they are named `run-example` and `run-example-no-result` respectively .

Here is what you should see when you run `make run-example`:

```
% make run-example
curl -i -X POST "http://localhost:3000/api/v1/rates/find" \
		-H "accept: application/json" -H "Content-Type: application/json" -d \
		"{ \"start_time\": \"2015-07-01T07:00:00-05:00\", \"end_time\": \"2015-07-01T12:00:00-05:00\"}"
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
ETag: W/"87820f968fa7488d92c1883e8d01ab65"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: e7b39d7e-c795-4017-a372-b97abcec83d0
X-Runtime: 0.009540
Transfer-Encoding: chunked

{"result":1750,"msg":null}%
```
