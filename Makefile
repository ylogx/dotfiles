apply:
	chezmoi apply --verbose

test:
	@if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then \
		docker build --tag dotfiles-test .; \
	elif command -v nerdctl >/dev/null 2>&1; then \
		nerdctl build --tag dotfiles-test .; \
	else \
		echo "No container runtime found (docker or nerdctl)" >&2; exit 1; \
	fi

lint:
	shellcheck -S warning install.sh run_ansible.sh $$(find home/bin -name 'executable_*' ! -name '*.py')
