build:
	mkdir -p lib
	rm -rf lib/*
	node_modules/.bin/coffee --compile -m --output js/ coffee/

watch:
	node_modules/.bin/coffee --watch --compile --output js/ coffee/
	
test:
	node_modules/.bin/mocha js/test/*.js --compilers coffee:coffee-script --reporter spec

jumpstart:
	npm install
	curl -u 'meryn' https://api.github.com/user/repos -d '{"name":"faithful", "description":"Like async, but employing promises.","private":false}'
	mkdir -p src
	touch src/faithful.coffee
	mkdir -p test
	touch test/faithful.coffee
	git init
	git remote add origin git@github.com:meryn/faithful
	git add .
	git commit -m "jumpstart commit."
	git push -u origin master

.PHONY: test