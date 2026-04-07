lint:
	prettier -w .

build:
	sudo docker build --tag dotfiles .

apply:
	chezmoi apply --verbose

# Legacy homeshick link (deprecated - use 'make apply')
link:
	chezmoi apply --verbose
