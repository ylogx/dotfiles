lint:
	prettier -w .

build:
	sudo docker build --tag dotfiles .
