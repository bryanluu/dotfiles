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

## Framework Desktop
Configuration from my 2025 Framework Desktop:
- `.zshrc` terminal config
- `.tmux.conf` tmux config
- `.gitconfig` git aliases

## Macbook Pro
Configuration from my 2023 Macbook Pro for work + life:
- `config/`
  - `Code/User/` VS-Code config
    - `settings.json` user settings
    - `keybindings.json` user keybindings
- `.zshrc` terminal config
- `.gitignore` useful gitignore

## Framework Laptop
Configuration from my 2022 Framework Laptop 11 to match HOME directory:
- `config/`
  - `Code/User/` VS-Code config
    - `settings.json` user settings
    - `keybindings.json` user keybindings
  - Clojure config (mostly copied https://github.com/seancorfield/vscode-calva-setup):
    - `calva/config.edn` Calva settings
    - `joyride/` Joyride settings
- `.zshrc` terminal config
- `.gitignore` useful gitignore
- `.tmux.conf` tmux config
