build:
	mkdir -p lib
	rm -rf js/*
	node_modules/.bin/coffee --compile -m --output js/ coffee/

watch:
	node_modules/.bin/coffee --watch --compile --output js/ coffee/
	
test:
	node_modules/.bin/mocha js/test/*.js --require coffee-script --compilers coffee:coffee-script/register --reporter spec

.PHONY: test build
