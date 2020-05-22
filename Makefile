.PHONY: unit-test init

unit-test:
	cask exec ert-runner

init:
	cask init --dev
