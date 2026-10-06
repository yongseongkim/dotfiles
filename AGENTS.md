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
| `macos.sh`          | `defaults write` system prefs (appearance, keyboard, input sources, shortcuts, trackpad, dock, Finder, typing). Called by bootstrap; safe to re-run. |
| `Brewfile`          | Homebrew formulae, casks, `mas` App Store apps, `vscode` extensions (`brew bundle`). |
| `nvim/`             | LazyVim (Neovim) config, symlinked to `~/.config/nvim`.       |
| `ghostty/config`    | Ghostty terminal config, symlinked to `~/.config/ghostty/config`. |
| `vscode/settings.json` | VS Code user settings, symlinked into `~/Library/Application Support/Code/User/`. |
| `lazygit/config.yml` | lazygit config, symlinked into `~/Library/Application Support/lazygit/`. |
| `claude/`           | Claude Code `settings.json` and `commands/`, symlinked into `~/.claude/`. |
| `fonts/`            | Vendored font files, copied into `~/Library/Fonts`.            |
| `bin/`              | Dotfiles symlinked into `$HOME` (see below).                   |
| `README.md`         | Human setup instructions.                                      |

Files in `bin/` are symlinked into `$HOME` by `bootstrap.sh`
(`.zshrc`, `.p10k.zsh`, `.gitconfig`, `.gitignore_global`, `.tmux.conf`, `.vimrc`,
`.ideavimrc`). Editing the repo file edits the live config, and vice versa.

## Conventions

- The repo is **public**. Never commit secrets or machine-private config: SSH
  keys/config, cloud credentials, API tokens. List those under "Manual steps"
  in `README.md` instead.
- Shell scripts are POSIX `sh` (`#!/bin/sh`), not bash. Don't use bashisms.
- Code comments follow the rule in [Comments](#comments) below.
- Reference repo paths via the `DOTFILES="$HOME/dotfiles"` variable and absolute
  paths — never rely on the current working directory.
- New dotfiles go in `bin/` and must be added to the symlink block in
  `bootstrap.sh`. New fonts go in `fonts/` (already globbed by bootstrap).
- New system preferences go in `macos.sh`, grouped by the existing section
  headers, and must stay idempotent (safe to run repeatedly).
- `bootstrap.sh` uses `set -e`; guard commands that may exit non-zero on a
  second run (e.g. `asdf plugin add ... || true`).

## Comments

주석은 코드만 읽어서는 알 수 없는 것만 한국어로 적는다. 비즈니스 규칙이나 외부 시스템 제약처럼 코드에 드러나지 않는 이유, 코드를 따라 읽어도 한눈에 안 잡히는 분기 우선순위, 흔한 방식을 벗어난 결정은 적는다. "본 PR"처럼 그때만 통하는 말, 단계 번호나 시그니처처럼 코드가 이미 말해주는 것, 어느 시스템에서나 당연한 기술 상식, require·check 메시지의 되풀이는 적지 않는다.

무엇을 바꿨는지, 예전에 어땠는지는 PR 과 git log 에 남기고, 주석에는 지금 어떤지와 왜 그런지를 쓴다.

영어를 직역하지 않는다. 개념어는 영어 그대로 써도 되지만, 동사와 형용사는 그 코드에서 실제로 일어나는 일로 풀어 쓰고 일상에서 안 쓰는 한자어는 피한다. 아래는 직역(왼쪽)을 풀어 쓴(오른쪽) 예시다.

- 앱이 우리가 쓴 값을 덮어쓰지 않게 한다(clobber) → 시스템 설정 앱이 열려 있으면 여기서 쓴 값을 앱이 다시 덮어쓴다.
- Dock이 이 목록으로 초기화된다(reset) → Dock에 직접 추가한 앱은 이 스크립트를 다시 실행하면 사라진다.
- 현재 셸에 brew를 불러온다(load) → 방금 설치한 brew는 아직 이 셸의 PATH에 없다.
- 고정해 둔 lock 파일을 복원한다(restore) → Lazy install이 lazy-lock.json을 다시 쓰므로, 커밋된 파일을 되돌린 뒤 restore로 그 버전에 맞춘다.

한 줄에 한 문장을 쓴다. 긴 문장을 나눌 때는 절 경계에서 끊는다.

같은 설명을 두 번 쓰지 않는다. 두 곳에 필요하면 처음 한 곳에만 쓰고, 세 곳 이상이면 그 코드를 함수로 묶어 설명을 함수에 한 번만 둔다.

용어는 기존 용례를 grep 해서 맞춘다. macOS 설정 이름은 시스템 설정의 한국어 표기를 따른다(입력 소스, 보조 키, 탭하여 클릭하기).

Repo-specific notes:

- `echo` output stays in English; only comments are Korean.
- Hangul is double-width, so pad `macos.sh` section banners by display width
  to keep the closing `#` aligned.

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
- `claude/settings.json` is likewise rewritten by Claude Code (`/config`, plugin
  installs). Review the diff and drop transient keys like `feedbackSurveyState`.
- Third-party taps must also be listed in bootstrap's `brew trust --tap` line, or
  Homebrew 6 refuses to load their formulae.
- `mas` entries in the Brewfile need an App Store sign-in and run as root (sudo
  prompt). Without the sign-in `brew bundle` exits non-zero and `set -e` stops
  bootstrap; the fix is to sign in and re-run.
- Caps Lock remapping in `macos.sh` is keyed per keyboard (`vendor-product-0`;
  `0-0-0` is the Apple Silicon built-in). A new external keyboard needs its own
  entry: get its IDs from `hidutil list`.

## Verifying changes

- Syntax-check scripts: `sh -n bootstrap.sh && sh -n macos.sh`.
- Validate the Brewfile: `brew bundle list --file=Brewfile`.
- Check the Neovim config loads: `nvim --headless +q`.
- There is no test suite; changes are validated by running the scripts.

## Commits

End commit messages with the project's standard trailer when committing on
behalf of the user. Commit only when asked.
