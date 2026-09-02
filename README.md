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

This lives outside `$HOME`, so `stow` can't symlink it. It's linked in via a manually-created symlink so edits here take effect on the next `daemon-reload`, with no re-copy step needed — but this requires an extra SELinux step on Fedora, since files under `/etc/systemd/system/` need the `systemd_unit_file_t` context, which a symlinked file from `$HOME` won't have by default.

```bash
sudo ln -s ~/.dotfiles/main_framework/systemd-system-configs/ollama.service.d/override.conf \
  /etc/systemd/system/ollama.service.d/override.conf

# Required on Fedora (SELinux enforcing): relabel the target so systemd is allowed to read it
sudo semanage fcontext -a -t systemd_unit_file_t \
  "/home/$USER/.dotfiles/main_framework/systemd-system-configs/ollama.service.d/override.conf"
sudo restorecon -v ~/.dotfiles/main_framework/systemd-system-configs/ollama.service.d/override.conf

sudo systemctl daemon-reload
sudo systemctl restart ollama
```

Verify it actually applied (SELinux denials fail silently — the service still starts, just without the override):

```bash
sudo ausearch -m avc -ts recent   # should return nothing
sudo ss -tlnp | grep 11434        # should show *:11434, not 127.0.0.1:11434
```

**Simpler alternative** (no SELinux step, but edits require re-copying):

```bash
sudo cp systemd-system-configs/ollama.service.d/override.conf /etc/systemd/system/ollama.service.d/
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

This override enables the iGPU (Vulkan), binds Ollama to `0.0.0.0` so containers can reach it, sets a longer model load timeout for large models, and deprioritizes Ollama's CPU/IO usage so it doesn't starve the rest of the system.

### Starting the GUI (main-framework runs headless by default)

Since `main-framework` normally boots headless, if you need the GNOME desktop:

- Start the GUI immediately (no reboot):

```bash
  sudo systemctl isolate graphical.target
```

- Make GUI the default boot target going forward:

```bash
  sudo systemctl set-default graphical.target
```

- Revert to headless boot:

```bash
  sudo systemctl set-default multi-user.target
```

- Check current default:

```bash
  systemctl get-default
```

## Macbook Pro

Configuration from my 2023 Macbook Pro for work + life (`macbook_pro/`):

- `.zshrc` terminal config
- `.vimrc` Vim config
- `.tmux.conf` tmux config
- `.wezterm.lua` WezTerm config (replaces iTerm2 — avoids Shell Integration
  conflicts with OSC52 clipboard passthrough over SSH/tmux)
- `.gitignore` useful gitignore
- `.stow-local-ignore` excludes files from stow symlinking
- `.config/`
  - `Code/User/` VS-Code config
    - `settings.json` user settings
    - `keybindings.json` user keybindings
    - `tasks.json` build/task config
  - `nvim/init.lua` Neovim config (Lua)
  - Clojure config (mostly copied from <https://github.com/seancorfield/vscode-calva-setup>):
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
  - Clojure config (mostly copied from <https://github.com/seancorfield/vscode-calva-setup>):
    - `calva/config.edn` Calva settings
    - `joyride/` Joyride settings
