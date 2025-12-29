.PHONY: build format docs docs-serve

build:
	forge build

format:
	forge fmt

docs:
# 	forge doc
	docker build -t cassa-docs .

docs-serve: docs
# 	forge doc --watch --serve -p 3000
	docker run -p 8080:80 cassa-docs
