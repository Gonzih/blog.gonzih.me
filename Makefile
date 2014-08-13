default:
	make push

push:
	git push
	bundle exec rake generate
	bundle exec rake push
