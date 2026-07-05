# dotfiles

Personal macOS (Apple Silicon) setup: Homebrew packages, shell, vim/neovim,
fonts, and system preferences — all driven by `bootstrap.sh`.

## Setup

1. Install Xcode Command Line Tools (bootstrap will prompt if missing).
2. Clone this repo to `~/dotfiles`.
3. Run it:
   ```sh
   chmod +x ~/dotfiles/bootstrap.sh
   ~/dotfiles/bootstrap.sh
   ```
4. Open a new terminal (or `exec zsh`) to load the shell.
5. Launch Ghostty — its config (font Tab0 Mono K) is symlinked from
   [`ghostty/config`](ghostty/config), so no manual setup is needed.

## What bootstrap does

- Installs Homebrew and everything in [`Brewfile`](Brewfile) via `brew bundle`.
- Installs oh-my-zsh (unattended).
- Symlinks the dotfiles in [`bin/`](bin) into `$HOME` (`.zshrc`, `.p10k.zsh`,
  `.gitconfig`, `.gitignore_global`, `.tmux.conf`, `.vimrc`, `.ideavimrc`) and
  the Ghostty config into `~/.config/ghostty/config`.
- Installs vim-plug and vim plugins.
- Symlinks the LazyVim (Neovim) config in [`nvim/`](nvim) to `~/.config/nvim`
  (an existing real config directory is backed up to `~/.config/nvim.bak`).
- Copies fonts from [`fonts/`](fonts) into `~/Library/Fonts`.
- Installs Node via asdf.
- Applies macOS system preferences via [`macos.sh`](macos.sh).

## Layout

| Path                | Purpose                                            |
|---------------------|----------------------------------------------------|
| `bootstrap.sh`      | One-shot machine setup.                             |
| `macos.sh`          | macOS defaults: keyboard, trackpad, dock, typing.  |
| `Brewfile`          | Homebrew formulae and casks.                        |
| `nvim/`             | LazyVim (Neovim) config (symlinked to `~/.config/nvim`). |
| `ghostty/`          | Ghostty terminal config (symlinked to `~/.config`).|
| `fonts/`            | Vendored fonts.                                     |
| `bin/`              | Dotfiles symlinked into `$HOME`.                    |

## Notes

- macOS preferences can be re-applied any time with `sh macos.sh`.
- Some macOS settings need a logout/restart to take full effect.

For agent/automation guidance, see [`AGENTS.md`](AGENTS.md).
