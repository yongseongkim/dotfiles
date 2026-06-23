# dotfiles

Personal macOS (Apple Silicon) setup: Homebrew packages, shell, vim, fonts, and
system preferences — all driven by `bootstrap.sh`.

## Setup

1. Install Xcode Command Line Tools (bootstrap will prompt if missing).
2. Clone this repo to `~/dotfiles`.
3. Run it:
   ```sh
   chmod +x ~/dotfiles/bootstrap.sh
   ~/dotfiles/bootstrap.sh
   ```
4. Open a new terminal (or `exec zsh`) to load the shell.
5. iTerm/Terminal → set the font to **Tab0 Mono K** and pick the Solarized Dark
   color preset.

## What bootstrap does

- Installs Homebrew and everything in [`Brewfile`](Brewfile) via `brew bundle`.
- Installs oh-my-zsh (unattended).
- **Symlinks** the dotfiles in [`bin/`](bin) into `$HOME` (`.zshrc`,
  `.gitconfig`, `.gitignore_global`, `.tmux.conf`, `.vimrc`, `.ideavimrc`).
- Installs vim-plug, vim plugins, and coc.nvim settings.
- Copies fonts from [`fonts/`](fonts) into `~/Library/Fonts`.
- Installs Node via asdf.
- Applies macOS system preferences via [`macos.sh`](macos.sh).

## Layout

| Path                | Purpose                                            |
|---------------------|----------------------------------------------------|
| `bootstrap.sh`      | One-shot machine setup.                             |
| `macos.sh`          | macOS defaults: keyboard, trackpad, dock, typing.  |
| `Brewfile`          | Homebrew formulae and casks.                        |
| `coc-settings.json` | coc.nvim LSP configuration.                         |
| `fonts/`            | Vendored fonts.                                     |
| `bin/`              | Dotfiles symlinked into `$HOME`.                    |

## Notes

- macOS preferences can be re-applied any time with `sh macos.sh`.
- Some macOS settings need a logout/restart to take full effect.

For agent/automation guidance, see [`AGENTS.md`](AGENTS.md).
