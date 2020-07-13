###############################################################################
#
#
###############################################################################

.DEFAULT_GOAL := help

# Generates a help message. Borrowed from https://github.com/pydanny/cookiecutter-djangopackage.
help: ## Display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@perl -nle'print $& if m{^[\.a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

bumpversion: ## Tag the current version using semantinc versioning and git tags (default: minor)
	# bumpversion major
	bumpversion minor
	# bumpversion patch

clean: ## Remove generated byte code, coverage reports, and build artifacts
	find . -name '__pycache__' -exec rm -rf {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	coverage erase
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

test: clean ## Run tests
	coverage run --source="." -m pytest ./eox_core
	coverage report --fail-under=70

python-quality-test:
	pylint ./eox_core
	pycodestyle ./eox_core
	isort --check-only --recursive --diff ./eox_core

javascript-quality-test:
	./node_modules/.bin/eslint ./eox_core/**/*.js*
