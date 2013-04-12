build:
	mkdir -p lib
	node_modules/.bin/coffee --compile -m --output lib/ src/

watch:
	node_modules/.bin/coffee --watch --compile --output lib/ src/
	
test:
	node_modules/.bin/mocha

jumpstart:
	npm install
	curl -u 'meryn' https://api.github.com/user/repos -d '{"name":"faithfully", "description":"Like async, but employing promises.","private":false}'
	mkdir -p src
	touch src/faithfully.coffee
	mkdir -p test
	touch test/faithfully.coffee
	git init
	git remote add origin git@github.com:meryn/faithfully
	git add .
	git commit -m "jumpstart commit."
	git push -u origin master

.PHONY: test