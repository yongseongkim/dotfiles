# dotfiles

Personal macOS (Apple Silicon) setup — Homebrew packages, shell, vim/neovim,
fonts, and system preferences, all driven by `bootstrap.sh`.

## Setup

1. Sign in to the App Store app. The Brewfile installs App Store apps with
   `mas`, which can't sign in for you; without it `brew bundle` fails and
   bootstrap stops (sign in and re-run).
2. Clone this repo to `~/dotfiles` (bootstrap prompts to install the Xcode
   Command Line Tools if they're missing).
3. Run it:
   ```sh
   ~/dotfiles/bootstrap.sh
   ```
4. Log out and back in, so the keyboard settings (Caps Lock → Control, input
   sources) apply. Then open a new terminal to load the shell. Ghostty picks
   up its symlinked config automatically.

## What bootstrap does

- Installs Homebrew packages, casks, App Store apps, and VS Code extensions
  from [`Brewfile`](Brewfile), plus oh-my-zsh, Claude Code, and its `cship`
  statusline.
- Symlinks [`bin/`](bin) dotfiles into `$HOME`, the [`ghostty/`](ghostty)
  config into `~/.config`, [`vscode/`](vscode) and [`lazygit/`](lazygit)
  configs into `~/Library/Application Support`, and [`claude/`](claude)
  settings and slash commands into `~/.claude`.
- Symlinks the LazyVim config ([`nvim/`](nvim)) to `~/.config/nvim` (an existing
  real config is backed up to `nvim.bak`) and installs vim-plug for vim.
- Copies [`fonts/`](fonts) into `~/Library/Fonts`.
- Installs Node, Python, and Ruby via asdf (Python also provides `aws-gate`),
  and Rust via rustup.
- Applies macOS preferences via [`macos.sh`](macos.sh) — re-runnable; some
  settings need a logout/restart to take effect.

## Manual steps (not in this public repo)

- SSH keys and `~/.ssh/config` (e.g. the `homelab` host).
- Raycast: import settings via Raycast → Settings → Advanced → Import.
- Apps with no cask: Pencil (pencil.dev).

## Layout

| Path           | Purpose                                            |
|----------------|----------------------------------------------------|
| `bootstrap.sh` | One-shot machine setup.                            |
| `macos.sh`     | macOS defaults (keyboard, trackpad, dock, Finder, typing). |
| `Brewfile`     | Homebrew formulae, casks, App Store apps, VS Code extensions. |
| `nvim/`        | LazyVim config → `~/.config/nvim`.                 |
| `ghostty/`     | Ghostty config → `~/.config/ghostty`.              |
| `vscode/`      | VS Code user settings.                             |
| `lazygit/`     | lazygit config.                                    |
| `claude/`      | Claude Code settings + slash commands → `~/.claude`. |
| `fonts/`       | Vendored fonts.                                    |
| `bin/`         | Dotfiles symlinked into `$HOME`.                   |

For agent/automation guidance, see [`AGENTS.md`](AGENTS.md).
