HOSTNAME ?= $(shell hostname)
MODE ?= switch
NIXOS-REBUILD ?= nixos-rebuild
REBUILD = ${NIXOS-REBUILD} ${MODE} --flake .\#

local:
	sudo ${REBUILD}${HOSTNAME}

remote: hcde lssg

rxtp:
	sudo ${REBUILD}$@

hcde:
	${REBUILD}$@ --target-host root@$@ --build-host root@$@ --fast

lssg:
	${REBUILD}$@ --target-host root@$@ --fast

updatekeys:
	fd 'secrets.yaml' --exec sops updatekeys --yes

clean:
	sudo nix-collect-garbage -d && nix-collect-garbage -d
