lint:
	prettier -w .

build:
	sudo docker build --tag dotfiles .

link:
	~/.homesick/repos/homeshick/bin/homeshick link dotfiles --verbose
