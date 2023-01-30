<h1 align = "center">❄️nixfiles</h1>

<p align = "center">This is my NixOS/home-manager config files.</p>

<p align = "center">
  <a href = "https://nixos.org">
    <img src = "https://img.shields.io/static/v1?style=for-the-badge&logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=8aadf4"/>
  </a>
</p>

## 🌟 Preview

![hyprland](./assets/screenshots/hyprland.png)
![neovim](./assets/screenshots/neovim.png)

## ✨ Features

- **Multiple** NixOS configurations, including laptop, server
- Deployment secrets using **agenix**
- Full wayland environment using **Hyprland**, **waybar**
- Mixed GPU and **Nvidia** GPU using offload
- Powerful editor using my personal **neovim** configurations **[RX-Nvim](https://github.com/CnTeng/RX-Nvim)**
- Flexible **home-manager** configurations in each module
- Every module using **Catppuccin** as colorscheme
- **Self-hosted** services such as **bitwarden**, **miniflux**

## 🗄 Structure

- `flake.nix`: Entrypoint for hosts and home configurations.
- `assets`: Some images for example wallpaper
- `hosts`: NixOS configurations
  - `laptop`: Dell laptop - 16GB RAM, i7 9570h, GTX1650 | Hyprland
  - `server`: Tencent VPS - 4GB RAM, 2 vCPUs | Server
- `modules`: All configurations of one package add into one module
- `overlays`: Patches and overrides for some packages
- `pkgs`: Some custom packages
- `secrets`: Confidential information and secret keys

## 🛠 Installation

Clone this repository

```shell
git clone https://github.com/CnTeng/nixfiles.git
```

For laptop

```shell
# Using --impure due to nix-ld
sudo nixos-rebuild switch --flake .#laptop --impure
```

For server

```shell
# Using --impure due to nix-ld
sudo nixos-rebuild switch --flake .#server --impure
```

## ⭐ Credits

- [nix-config](https://github.com/Misterio77/nix-config/tree/main)
- [nixos-config](https://github.com/MatthiasBenaets/nixos-config)
