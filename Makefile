lint:
	prettier -w .

build:
	sudo docker build --tag dotfiles .

link:
	homeshick link dotfiles --verbose
