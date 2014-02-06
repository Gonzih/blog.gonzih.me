default:
	make push

push:
	git push
	rake generate
	rake push
