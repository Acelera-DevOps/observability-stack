.PHONY: help up down ps logs validate reload-prometheus clean

help: ## Show available observability stack commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

up: ## Start full OpenTelemetry + Prometheus + Grafana + Loki + Tempo + Alertmanager stack
	docker compose up -d

down: ## Stop all containers while preserving volumes
	docker compose down

ps: ## List running containers and exposed ports
	docker compose ps

logs: ## Follow container logs across the telemetry pipeline
	docker compose logs -f --tail=100

validate: ## Validate Docker Compose, Prometheus rules, YAML and Grafana JSON syntax
	docker compose config -q
	@echo "Docker Compose configuration is valid."

reload-prometheus: ## Hot-reload Prometheus configuration and alert rules without downtime
	curl -fsS -X POST http://localhost:9090/-/reload

clean: ## Stop containers and remove all persistent telemetry volumes
	docker compose down -v --remove-orphans
