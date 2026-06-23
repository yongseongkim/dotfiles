#!/bin/sh
#
# macOS system preferences. Safe to re-run.
# Some changes require a logout/restart to fully take effect.

echo "Applying macOS settings..."

# Don't open System Settings while we write (avoids clobbering our writes)
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Fast key repeat + short delay before repeating (lower = faster)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for accents so a held key repeats (vim-friendly)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Full keyboard access: Tab moves between all controls, not just text fields
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Tap to click (built-in trackpad + Bluetooth + login screen)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Faster tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5

###############################################################################
# Dock                                                                        #
###############################################################################

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock tilesize -int 64
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Typing (turn off "smart" substitutions that get in the way of code)        #
###############################################################################

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

###############################################################################
# Apply                                                                       #
###############################################################################

killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "macOS settings applied. Some changes need a logout/restart to take effect."
