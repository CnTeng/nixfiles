HOSTNAME ?= $(shell hostname)
MODE ?= switch
REBUILD = nixos-rebuild ${MODE} --flake .\#

local:
	sudo ${REBUILD}${HOSTNAME}

remote: hcde lssg

rxtp:
	sudo ${REBUILD}$@

hcde:
	${REBUILD}$@ --target-host $@ --build-host $@ --use-remote-sudo --fast

lssg:
	${REBUILD}$@ --target-host $@ --use-remote-sudo --fast

updatekeys:
	fd 'secrets.yaml' --exec sops updatekeys --yes

clean:
	sudo nix-collect-garbage -d && nix-collect-garbage -d
