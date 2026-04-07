apply:
	chezmoi apply --verbose

test:
	docker build --tag dotfiles-test .

lint:
	shellcheck -S warning install.sh run_ansible.sh home/bin/executable_*
