# dotfiles

Personal macOS (Apple Silicon) setup — Homebrew packages, shell, vim/neovim,
fonts, and system preferences, all driven by `bootstrap.sh`.

## Setup

1. Clone this repo to `~/dotfiles` (bootstrap prompts to install the Xcode
   Command Line Tools if they're missing).
2. Run it:
   ```sh
   ~/dotfiles/bootstrap.sh
   ```
3. Open a new terminal (or `exec zsh`) to load the shell. Ghostty picks up its
   symlinked config automatically.

## What bootstrap does

- Installs Homebrew packages from [`Brewfile`](Brewfile), oh-my-zsh, and
  Claude Code.
- Symlinks [`bin/`](bin) dotfiles into `$HOME` and the [`ghostty/`](ghostty)
  config into `~/.config`.
- Symlinks the LazyVim config ([`nvim/`](nvim)) to `~/.config/nvim` (an existing
  real config is backed up to `nvim.bak`) and installs vim-plug for vim.
- Copies [`fonts/`](fonts) into `~/Library/Fonts`.
- Installs Node and Python via asdf (Python also provides `aws-gate`).
- Applies macOS preferences via [`macos.sh`](macos.sh) — re-runnable; some
  settings need a logout/restart to take effect.

## Layout

| Path           | Purpose                                            |
|----------------|----------------------------------------------------|
| `bootstrap.sh` | One-shot machine setup.                            |
| `macos.sh`     | macOS defaults (keyboard, trackpad, dock, typing). |
| `Brewfile`     | Homebrew formulae and casks.                       |
| `nvim/`        | LazyVim config → `~/.config/nvim`.                 |
| `ghostty/`     | Ghostty config → `~/.config/ghostty`.              |
| `fonts/`       | Vendored fonts.                                    |
| `bin/`         | Dotfiles symlinked into `$HOME`.                   |

For agent/automation guidance, see [`AGENTS.md`](AGENTS.md).
