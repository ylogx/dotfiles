lint:
	prettier -w .

build:
	sudo docker build --tag dotfiles .

apply:
	chezmoi apply --verbose
