.ONESHELL:

-include .env

HOSTNAME			:= $(shell hostname)
REBUILD     	:= nixos-rebuild
MODE        	?= switch
FLAGS       	?= $(MODE) --flake .\#
REMOTE_FLAGS	?= $(FLAGS)$@ --target-host root@$@

local:
	sudo $(REBUILD) $(FLAGS)$(HOSTNAME)

remote: hcde lssg

hcde:
	$(REBUILD) $(REMOTE_FLAGS) --build-host root@$@

lssg:
	$(REBUILD) $(REMOTE_FLAGS)

IP						:= $(HOSTNAME)
INSTALL_FLAGS	:= --flake .\#$(HOSTNAME) \
								 --target-host root@$(IP) \
								 --extra-files "$(EXTRA_FILES)"
EXTRA_FLAGS		:=

install:
	nixos-anywhere $(INSTALL_FLAGS) $(EXTRA_FLAGS)

generate-key:
	@set -e
	tmp_dir=$$(mktemp -d -t "age-key.XXXXXXXXXX")
	key_path="$$tmp_dir/persist/var/lib/sops-nix"

	echo "Extra files: $$tmp_dir"
	mkdir -p "$$key_path" && chmod 700 "$$key_path"
	age-keygen --output "$$key_path/key"

	echo "EXTRA_FILES=$$tmp_dir" >.env
	echo "Age key generated successfully."

update-keys:
	fd 'secrets.yaml' --exec sops updatekeys --yes

rotate-keys:
	fd 'secrets.yaml' --exec sops rotate -i

clean:
	sudo nix-collect-garbage -d && nix-collect-garbage -d
