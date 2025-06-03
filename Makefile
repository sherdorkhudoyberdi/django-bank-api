build:
	docker compose -f local.yml up --build -d --remove-orphans

up:
	docker compose -f local.yml up -d

# SAFE: Stops containers without removing volumes (preserves data)
down:
	docker compose -f local.yml down

# DANGEROUS: Removes all data. Only use when you want to completely reset the database
down-v:
	@echo "WARNING: This will delete all your data!"
	@echo "Are you sure you want to continue? [y/N]"
	@read -p " " answer; \
	if [ "$$answer" = "y" ]; then \
		docker compose -f local.yml down -v; \
	else \
		echo "Operation cancelled"; \
	fi

banker-config:
	docker compose -f local.yml config

makemigrations:
	docker compose -f local.yml run --rm --entrypoint python api manage.py makemigrations

migrate:
	docker compose -f local.yml run --rm api python manage.py migrate

collectstatic:
	docker compose -f local.yml run --rm api python manage.py collectstatic --no-input --clear

superuser:
	docker compose -f local.yml run --rm --entrypoint python api manage.py createsuperuser

flush:
	docker compose -f local.yml run --rm api python manage.py flush

network-inspect:
	docker network inspect api_banker_local_nw

banker-db:
	docker compose -f local.yml exec postgres psql --username=sherdor --dbname=banker