.DEFAULT_GOAL := help

console: ## Jump into the console and interact with the services
	bundle exec rails console
.PHONY: console

run: ## Run the app with an example file
	bundle exec rails server
.PHONY: console

test: ## Run the tests
	bundle exec rspec spec
.PHONY: console

generate-swagger-doc: ## Run the app with piped-in text
	bundle exec rake rswag:specs:swaggerize
.PHONY: console

setup: ## Sets up the app using Docker and Docker Compose
	docker-compose build
	# docker-compose run --rm web rails db:create db:migrate
	docker-compose up -d

hop-on: ## Jump on the docker instance
	docker exec -ti ratefinder_web_1 /bin/bash

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
