#!/bin/sh
#
# bootstrap.sh가 호출하지만, 단독으로 여러 번 실행해도 결과가 같다.

echo "Applying macOS settings..."

# 시스템 설정 앱이 열려 있으면 여기서 쓴 값을 앱이 다시 덮어쓴다.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# 화면 모양 & 창                                                              #
###############################################################################

defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

# 화면 가장자리로 끌어 붙인 창들 사이에 틈을 두지 않는다.
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

###############################################################################
# 키보드                                                                      #
###############################################################################

# 값이 작을수록 빠르다.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 키를 누르고 있으면 악센트 선택 창을 띄우지 않고 같은 글자를 반복 입력한다.
# vim에서 hjkl을 누른 채로 이동하려면 이렇게 해야 한다.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Tab이 텍스트 필드뿐 아니라 버튼 같은 모든 컨트롤로 이동한다.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Caps Lock을 Control로 바꾼다.
# 이 매핑과 아래 입력 소스는 다음 로그인부터 적용된다.
# 30064771129는 Caps Lock(0x700000039), 30064771300은 Control(0x7000000E4)의 HID 키 코드다.
# 매핑은 키보드마다 vendor-product 값으로 따로 저장된다.
# 0-0-0은 Apple Silicon 내장 키보드이고, 1452-544-0은 외장 BT5.0Keyboard다.
for kb in 0-0-0 1452-544-0; do
	defaults -currentHost write NSGlobalDomain "com.apple.keyboard.modifiermapping.$kb" -array \
		"<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771300</integer></dict>"
done

# 배열을 통째로 덮어쓰므로 남길 입력 소스를 모두 적는다.
defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
	"<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>252</integer><key>KeyboardLayout Name</key><string>ABC</string></dict>" \
	"<dict><key>Bundle ID</key><string>com.apple.inputmethod.Korean</string><key>Input Mode</key><string>com.apple.inputmethod.Korean.2SetKorean</string><key>InputSourceKind</key><string>Input Mode</string></dict>" \
	"<dict><key>Bundle ID</key><string>com.apple.inputmethod.Korean</string><key>InputSourceKind</key><string>Keyboard Input Method</string></dict>" \
	"<dict><key>Bundle ID</key><string>com.apple.CharacterPaletteIM</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>"

# hotkey <id> <true|false> <문자 코드> <키 코드> <보조 키 마스크>
# Space는 문자 코드 32, 키 코드 49다.
# 보조 키 마스크는 Control 262144, Option 524288, Command 1048576을 더한 값이다.
hotkey() {
	defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
		"<dict><key>enabled</key><$2/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>$3</integer><integer>$4</integer><integer>$5</integer></array></dict></dict>"
}
# 입력 메뉴에서 다음 소스 선택(61)을 Ctrl+Space로 쓴다.
# 이전 입력 소스 선택(60)은 기본 단축키가 Ctrl+Space라 겹치므로, Ctrl+Opt+Space로 옮기고 끈다.
hotkey 60 false 32 49 786432
hotkey 61 true  32 49 262144
# Cmd+Space는 Raycast가 쓰므로 Spotlight(64)를 끈다.
hotkey 64 false 32 49 1048576

###############################################################################
# 트랙패드                                                                    #
###############################################################################

# 탭하여 클릭하기는 내장 트랙패드, Bluetooth 트랙패드, 로그인 화면에 설정이 따로 있어서 모두 켠다.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5

###############################################################################
# Dock                                                                        #
###############################################################################

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock tilesize -int 64
defaults write com.apple.dock show-recents -bool false

# 기본으로 고정된 앱을 모두 비우고 아래 앱만 넣는다.
# 그래서 Dock에 직접 추가한 앱은 이 스크립트를 다시 실행하면 사라진다.
dock_add() {
	[ -e "$1" ] || return 0
	defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

defaults write com.apple.dock persistent-apps -array
dock_add "/Applications/Ghostty.app"
dock_add "/Applications/Google Chrome.app"
dock_add "/Applications/Slack.app"
dock_add "/Applications/Visual Studio Code.app"

###############################################################################
# Finder                                                                      #
###############################################################################

# Nlsv는 목록 보기다.
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# 입력 (코드 작성에 방해되는 "스마트" 자동 치환 끄기)                         #
###############################################################################

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

###############################################################################
# 적용                                                                        #
###############################################################################

# activateSettings -u는 바뀐 단축키를 로그아웃 없이 바로 적용한다.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "macOS settings applied. Some changes need a logout/restart to take effect."
