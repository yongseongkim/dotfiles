# AGENTS.md

Guidance for AI agents working in this repository.

## What this is

Personal macOS dotfiles for a single user. `bootstrap.sh` sets up a fresh
Mac end to end: Homebrew packages, shell, vim/neovim, fonts, and system
preferences. Target platform is macOS on Apple Silicon (Homebrew at
`/opt/homebrew`).

## Layout

| Path                | Purpose                                                        |
|---------------------|----------------------------------------------------------------|
| `bootstrap.sh`      | One-shot machine setup. Run from a fresh checkout.             |
| `macos.sh`          | `defaults write` system prefs (keyboard, trackpad, dock, typing). Called by bootstrap; safe to re-run. |
| `Brewfile`          | Homebrew formulae + casks (`brew bundle`).                     |
| `nvim/`             | LazyVim (Neovim) config, symlinked to `~/.config/nvim`.       |
| `ghostty/config`    | Ghostty terminal config, symlinked to `~/.config/ghostty/config`. |
| `fonts/`            | Vendored font files, copied into `~/Library/Fonts`.            |
| `bin/`              | Dotfiles symlinked into `$HOME` (see below).                   |
| `README.md`         | Human setup instructions.                                      |

Files in `bin/` are symlinked into `$HOME` by `bootstrap.sh`
(`.zshrc`, `.p10k.zsh`, `.gitconfig`, `.gitignore_global`, `.tmux.conf`, `.vimrc`,
`.ideavimrc`). Editing the repo file edits the live config, and vice versa.

## Conventions

- Shell scripts are POSIX `sh` (`#!/bin/sh`), not bash. Don't use bashisms.
- Reference repo paths via the `DOTFILES="$HOME/dotfiles"` variable and absolute
  paths — never rely on the current working directory.
- New dotfiles go in `bin/` and must be added to the symlink block in
  `bootstrap.sh`. New fonts go in `fonts/` (already globbed by bootstrap).
- New system preferences go in `macos.sh`, grouped by the existing section
  headers, and must stay idempotent (safe to run repeatedly).
- `bootstrap.sh` uses `set -e`; guard commands that may exit non-zero on a
  second run (e.g. `asdf plugin add ... || true`).

## Gotchas

- asdf 0.16+ (the Go rewrite, what Homebrew installs) removed `asdf.sh` and
  `asdf global`. `.zshrc` adds `$ASDF_DATA_DIR/shims` to `PATH`; bootstrap uses
  `asdf set -u`. Don't reintroduce `source .../asdf.sh`.
- `aws-gate` is a pip tool on asdf's Python 3.10 (installed by `bootstrap.sh`),
  not a Homebrew formula: its pinned `cffi` only builds on 3.10 and brew forces a
  newer Python. Keep it on asdf; don't move it into the Brewfile.
- `.zshrc` auto-launches `tmux` on shell start, so never `source ~/.zshrc` from
  inside a script — it will hang.
- The `[maintenance]` repo path in `bin/.gitconfig` is a machine-local absolute
  path; it only applies on this Mac.
- `nvim/lazy-lock.json` is rewritten by lazy.nvim on `:Lazy update`/`:Lazy sync`.
  That diff is expected — commit it as-is to pin plugin versions across machines.

## Verifying changes

- Syntax-check scripts: `sh -n bootstrap.sh && sh -n macos.sh`.
- Validate the Brewfile: `brew bundle list --file=Brewfile`.
- Check the Neovim config loads: `nvim --headless +q`.
- There is no test suite; changes are validated by running the scripts.

## Commits

End commit messages with the project's standard trailer when committing on
behalf of the user. Commit only when asked.
