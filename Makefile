.PHONY: build format docs docs-serve

build:
	forge build

format:
	forge fmt

docs:
	forge doc

docs-serve:
	forge doc --watch --serve -p 3000
