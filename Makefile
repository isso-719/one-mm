.PHONY: run
run:
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose down

.PHONE: restart
restart:
	docker-compose down && docker-compose up -d

.PHONY: build
build:
	docker-compose build

.PHONY: clean
clean:
	docker-compose down --volume

.PHONY: logs
logs:
	docker-compose logs -f

.PHONY: open
open:
	open http://localhost:8080

.PHONY: bundle
bundle:
	docker-compose run --rm web bundle install

.PHONY: deploy
deploy:
	sh scripts/cloudrun_deploy.sh