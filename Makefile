HOSTNAME     = $(shell hostname)
REBUILD     := nixos-rebuild
MODE        := switch
FLAGS        = $(MODE) --flake .\#
REMOTE_FLAGS = $(FLAGS)$@ --fast --target-host root@$@

all: local

local:
	sudo $(REBUILD) $(FLAGS)$(HOSTNAME)

remote: hcde lssg

hcde:
	$(REBUILD) $(REMOTE_FLAGS) --build-host root@$@

lssg:
	$(REBUILD) $(REMOTE_FLAGS)

updatekeys:
	fd 'secrets.yaml' --exec sops updatekeys --yes

clean:
	sudo nix-collect-garbage -d && nix-collect-garbage -d
