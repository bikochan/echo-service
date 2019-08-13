.DEFAULT_GOAL := help
.PHONY: help pysetup gosetup clean proj

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Cleanup this mess
	@rm -rf venv

proj: ## Create new empty project
	touch README.md .gitignore .dockerignore .envrc
	if [[ ! -d .git ]]; then git init; fi

pysetup: ## Setup python virtual environment
	@echo "export VIRTUAL_ENV=venv" >> .envrc
	@echo "layout python-venv" >> .envrc
	@echo "echo Loading Python venv" >> .envrc
	@touch requirements.txt .gitignore
	@if [[ $$(egrep -c ^venv .gitignore) -eq 0 ]]; then echo venv >> .gitignore; fi

gosetup: ## Setup golang environment in direnv
	@echo export GOPATH=$${PWD} >> .envrc
	@echo export GOARCH=$$(uname -m) >> .envrc
	@echo export GOOS=$$(uname -s) >> .envrc
	@echo export GO111MODULE=on >> .envrc
	@echo PATH_add $${PWD}/bin >> .envrc
	go mod init

docker-image: Dockerfile echo.go ## Build docker image
	docker build -t echo-service:latest .

