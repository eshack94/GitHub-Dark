node_modules: package-lock.json
	npm install --no-save
	@touch node_modules

.PHONY: test
test: lint

.PHONY: build
build: node_modules clean
	node tools/build.js

.PHONY: deps
deps: node_modules

.PHONY: lint
lint: node_modules
	npx eslint --color src/gen tools
	npx stylelint --color src

.PHONY: authors
authors:
	bash tools/authors.sh

.PHONY: clean
clean: node_modules
	node tools/clean.js

.PHONY: install
install: node_modules
	node tools/install.js

.PHONY: update
update: node_modules build
	npx updates -cu
	rm package-lock.json
	npm install
	@touch node_modules

.PHONY: patch
patch: node_modules test
	npx versions -pd patch $(wildcard *.user.css)
	git push --tags origin master

.PHONY: minor
minor: node_modules test
	npx versions -pd minor $(wildcard *.user.css)
	git push --tags origin master

.PHONY: major
major: node_modules test
	npx versions -pd major $(wildcard *.user.css)
	git push --tags origin master
