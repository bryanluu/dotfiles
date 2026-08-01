# dotfiles
This repo contains my configuration settings for development

## Installation
- Ensure GNU [`stow`](https://www.gnu.org/software/stow/) is installed.
- Ensure this repo is installed on the machine somewhere consistent (e.g. `~/.dotfiles`):

```bash
git clone git@github.com:bryanluu/dotfiles.git
```
- Navigate to the desired configuration folder. E.g. for my Framework Laptop
```bash
cd framework_laptop
```
- Dry-run `stow` to test the configuration install:
```bash
stow -nv . --target=$HOME
```
- If all looks good, run it for real:
```bash
stow -v . --target=$HOME
```

## Main Framework (2025 Framework Desktop)
Configuration from my 2025 Framework Desktop (`main_framework/`):
- `.zshrc` terminal config
- `.tmux.conf` tmux config
- `.vimrc` Vim config
- `.wezterm.lua` WezTerm config (native Copr install)
- `.gitconfig` git aliases
- `.gitignore` useful gitignore
- `.stow-local-ignore` excludes non-stowable files (system configs) from symlinking
- `.config/`
  - `Code/User/` VS-Code config
    - `settings.json` user settings
    - `keybindings.json` user keybindings
  - `nvim/init.lua` Neovim config (Lua)
  - `systemd/user/` user-level services
    - `bitwarden.service` Bitwarden SSH agent autostart
    - `protonvpn-autostart.service` ProtonVPN autostart
  - `containers/systemd/open-webui.container` Podman Quadlet — runs Open WebUI as an auto-starting systemd service (requires `loginctl enable-linger $USER`)
- `systemd-system-configs/` — root-owned system files, tracked for reference only (excluded from stow via `.stow-local-ignore`)

### Applying the Ollama service override
This lives outside `$HOME`, so `stow` can't symlink it — apply manually on a fresh machine:
```bash
sudo mkdir -p /etc/systemd/system/ollama.service.d
sudo cp systemd-system-configs/ollama.service.d/override.conf /etc/systemd/system/ollama.service.d/
sudo systemctl daemon-reload
sudo systemctl restart ollama
```
This override enables the iGPU (Vulkan), binds Ollama to `0.0.0.0` so containers can reach it, sets a longer model load timeout for large models, and deprioritizes Ollama's CPU/IO usage so it doesn't starve the rest of the system.

## Macbook Pro
Configuration from my 2023 Macbook Pro for work + life (`macbook_pro/`):
- `.zshrc` terminal config
- `.vimrc` Vim config
- `.tmux.conf` tmux config
- `.gitignore` useful gitignore
- `.stow-local-ignore` excludes files from stow symlinking
- `.config/`
  - `Code/User/` VS-Code config
    - `settings.json` user settings
    - `keybindings.json` user keybindings
    - `tasks.json` build/task config
  - `nvim/init.lua` Neovim config (Lua)
  - Clojure config (mostly copied from https://github.com/seancorfield/vscode-calva-setup):
    - `calva/config.edn` Calva settings
    - `joyride/` Joyride settings

## Framework Laptop
Configuration from my 2022 Framework Laptop 11 to match HOME directory (`framework_laptop/`):
- `.zshrc` terminal config
- `.tmux.conf` tmux config
- `.gitconfig` git aliases
- `.gitignore` useful gitignore
- `.config/`
  - `Code/User/` VS-Code config
    - `settings.json` user settings
    - `keybindings.json` user keybindings
    - `tasks.json` build/task config
  - Clojure config (mostly copied from https://github.com/seancorfield/vscode-calva-setup):
    - `calva/config.edn` Calva settings
    - `joyride/` Joyride settings
