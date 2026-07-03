.PHONY: help build test deploy clean setup

help:
	@echo "ZeroDPD - Loan Recovery Platform"
	@echo ""
	@echo "Available targets:"
	@echo "  setup          - Setup development environment"
	@echo "  build          - Build all services"
	@echo "  test           - Run all tests"
	@echo "  test-unit      - Run unit tests only"
	@echo "  test-int       - Run integration tests only"
	@echo "  docker-build   - Build Docker images"
	@echo "  docker-up      - Start Docker Compose stack"
	@echo "  docker-down    - Stop Docker Compose stack"
	@echo "  deploy-k8s     - Deploy to Kubernetes"
	@echo "  clean          - Clean build artifacts"
	@echo "  logs           - View service logs"

setup:
	@echo "Setting up development environment..."
	cd api-gateway && mvn clean install
	cd ../ai-platform && pip install -r requirements.txt
	cd ../agent-workbench/frontend && npm install

test:
	@echo "Running all tests..."
	./scripts/test-all.sh

test-unit:
	@echo "Running unit tests..."
	./scripts/test-unit.sh

test-int:
	@echo "Running integration tests..."
	./scripts/test-integration.sh

docker-build:
	@echo "Building Docker images..."
	docker-compose build

docker-up:
	@echo "Starting Docker Compose stack..."
	docker-compose up -d

docker-down:
	@echo "Stopping Docker Compose stack..."
	docker-compose down

deploy-k8s:
	@echo "Deploying to Kubernetes..."
	./scripts/deploy-k8s.sh

clean:
	@echo "Cleaning build artifacts..."
	find . -type d -name "target" -exec rm -rf {} +
	find . -type d -name "build" -exec rm -rf {} +
	find . -type d -name "dist" -exec rm -rf {} +

logs:
	@echo "Viewing service logs..."
	docker-compose logs -f
