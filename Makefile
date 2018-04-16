push:
	git push

go-get-update:
	go get -u github.com/spf13/hugo

generate:
	hugo

preview:
	hugo server

TS := $(date)
public:
	git clone -b master git@github.com:Gonzih/gonzih.github.com.git public

deploy: public
	cd public && git add  . && git commit -a -m "Blog updated at $(shell date)" && git push
	cd ..

docker-image:
	docker build -t blog-builder .

generate-using-docker: docker-image
	docker run --rm -t -v $(shell pwd):/var/blog --name blog-builder blog-builder make generate

deploy-using-docker:
	make generate-using-docker
	make deploy
	make push

preview-using-docker: docker-image
	docker run --rm -t -v $(shell pwd):/var/blog -p 1313:1313 --name blog-builder blog-builder make preview

debug-using-docker: docker-image
	docker run --rm -ti -v $(shell pwd):/var/blog -p 1313:1313 --name blog-builder blog-builder bash
