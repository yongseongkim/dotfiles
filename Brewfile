# 서드파티 tap
tap 'adembc/tap'
tap 'hashicorp/tap'
tap 'tw93/tap'

brew 'wget'
brew 'fzf'
brew 'gh'
brew 'git-lfs'
brew 'gradle'
brew 'protobuf'
brew 'lazygit'
brew 'lazyjj'
brew 'adembc/tap/lazyssh'
brew 'tw93/tap/mole'
brew 'tmux'
brew 'neovim'
brew 'tree-sitter-cli'
brew 'asdf'
brew 'libyaml' # asdf가 Ruby를 소스에서 빌드할 때 쓴다
brew 'uv'
brew 'deno'
brew 'zoxide'
brew 'ffmpeg'
brew 'powerlevel10k'
brew 'starship' # cship 상태 표시줄의 $directory, $git_branch 같은 모듈이 starship을 실행해 값을 얻는다
brew 'mas'

# 비밀 정보 / 암호화
brew 'age'
brew 'sops'

# 클라우드 CLI
brew 'awscli'
brew 'oci-cli'
brew 'gemini-cli'
brew 'googleworkspace-cli'
brew 'hashicorp/tap/terraform'

# 애플리케이션
cask_args appdir: '/Applications'
cask '1password'
cask 'google-chrome'
cask 'ghostty'
cask 'jetbrains-toolbox'
cask 'visual-studio-code'
cask 'dbeaver-community'
cask 'docker-desktop'
cask 'notion'
cask 'notion-calendar'
cask 'obsidian'
cask 'figma'
cask 'slack'
cask 'raycast'
cask 'alt-tab'
cask 'tailscale-app'
cask 'aws-vault-binary'
cask 'gcloud-cli'

# AI 앱과 코딩 에이전트
# claude-code는 스스로 업데이트하므로 cask 대신 bootstrap.sh에서 공식 설치 스크립트로 설치한다.
cask 'claude'
cask 'chatgpt'
cask 'codex'

# Mac App Store
# mas는 직접 로그인할 수 없으므로 App Store 앱에 미리 로그인해 둬야 한다.
# 로그인돼 있지 않으면 brew bundle이 실패하고 bootstrap도 멈춘다.
# 설치가 root 권한으로 돌아가서 mas가 비밀번호를 묻는다.
mas 'Amphetamine', id: 937984704
mas 'BetterSnapTool', id: 417375580
mas 'KakaoTalk', id: 869223134
mas 'Telegram', id: 747648890
mas 'Xcode', id: 497799835 # 다운로드 용량이 크다

# VS Code 확장
vscode 'arcanis.vscode-zipfs'
vscode 'asvetliakov.vscode-neovim'
vscode 'dbaeumer.vscode-eslint'
vscode 'esbenp.prettier-vscode'
vscode 'hashicorp.terraform'
vscode 'mechatroner.rainbow-csv'
vscode 'ms-python.debugpy'
vscode 'ms-python.python'
vscode 'ms-python.vscode-pylance'
vscode 'ms-python.vscode-python-envs'
vscode 'qiqigou.tpl-lang'
vscode 'scala-lang.scala'
