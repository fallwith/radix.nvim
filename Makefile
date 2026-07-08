.PHONY: test

test:
	nvim --headless -u tests/minimal_init.lua -c "lua dofile('tests/run.lua')" -c qa
	@test -z "$$(rg -l '#[0-9a-fA-F]{6}' --glob '!lua/radix/palette/*.lua' --glob '!README.md' .)" || \
		(echo 'hex colors must only be defined in lua/radix/palette/'; exit 1)
