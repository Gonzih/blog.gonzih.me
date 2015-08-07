default:
		make deploy-using-docker

push:
	git push

bundle-install:
	bundle install --path vendor/bundle

generate: bundle-install
	bundle exec rake generate

preview: bundle-install
	bundle exec rake generate
	bundle exec rake preview

_deploy:
	git clone -b master git@github.com:Gonzih/gonzih.github.com.git _deploy

deploy: _deploy
	bundle exec rake push

docker-image:
	docker build -t blog-builder .

generate-using-docker: docker-image
	docker run --rm=true -t -v $(shell pwd):/var/blog blog-builder make generate

deploy-using-docker:
	make generate-using-docker
	make deploy
	make push

preview-using-docker: docker-image
		docker run --rm=true -t -v $(shell pwd):/var/blog -p 4000:4000 blog-builder make preview

debug-using-docker: docker-image
		docker run --rm=true -ti -v $(shell pwd):/var/blog -p 4000:4000 blog-builder bash
