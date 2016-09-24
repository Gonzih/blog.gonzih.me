push:
	git push

go-get-update:
	go get -u github.com/spf13/hugo

go-get:
	go get github.com/spf13/hugo

generate: go-get
	hugo

preview: go-get
	hugo server

public:
	git clone -b master git@github.com:Gonzih/gonzih.github.com.git public

deploy: public
	cd public && git add  . && git commit -a -m "Blog updated" && git push

docker-image:
	docker build -t blog-builder .

generate-using-docker: docker-image
	docker run --rm=true -t -v $(shell pwd):/var/blog --name blog-builder blog-builder make generate

deploy-using-docker:
	make generate-using-docker
	make deploy
	make push

preview-using-docker: docker-image
	docker run --rm=true -t -v $(shell pwd):/var/blog -p 4000:4000 --name blog-builder blog-builder make preview

debug-using-docker: docker-image
	docker run --rm=true -ti -v $(shell pwd):/var/blog -p 4000:4000 --name blog-builder blog-builder bash
