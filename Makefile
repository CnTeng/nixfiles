.ONESHELL:

-include .env

HOSTNAME	:= $(shell hostname)
HOSTADDR	:= $(HOSTNAME)

# NixOS rebuild
REBUILD     	:= nixos-rebuild
MODE        	?= switch
LOCAL_FLAGS		?= $(MODE) --flake .\#
REMOTE_FLAGS	?= $(LOCAL_FLAGS)$@ --target-host root@$@

.PHONY: local
local:
	sudo $(REBUILD) $(LOCAL_FLAGS)$(HOSTNAME)

.PHONY: remote
remote: hcde lssg

.PHONY: hcde
hcde:
	$(REBUILD) $(REMOTE_FLAGS) --build-host root@$@

.PHONY:	lssg
lssg:
	$(REBUILD) $(REMOTE_FLAGS)

# NixOS installation
INSTALL_FLAGS	:= --flake .\#$(HOSTNAME) \
								 --target-host root@$(HOSTADDR) \
								 --extra-files "$(EXTRA_FILES)"
EXTRA_FLAGS		:=

.PHONY:	install
install:
	nixos-anywhere $(INSTALL_FLAGS) $(EXTRA_FLAGS)

# Keys management
.PHONY:	generate-key
generate-key:
	@set -e
	tmp_dir=$$(mktemp -d -t "age-key.XXXXXXXXXX")
	key_path="$$tmp_dir/persist/var/lib/sops-nix"

	echo "Extra files: $$tmp_dir"
	mkdir -p "$$key_path" && chmod 700 "$$key_path"
	age-keygen --output "$$key_path/key"

	echo "EXTRA_FILES=$$tmp_dir" >.env
	echo "Age key generated successfully."

.PHONY: update-keys
update-keys:
	fd 'secrets.yaml' --exec sops updatekeys --yes

.PHONY: rotate-keys
rotate-keys:
	fd 'secrets.yaml' --exec sops rotate -i

.PHONY: clean
clean:
	sudo nix-collect-garbage -d && nix-collect-garbage -d
