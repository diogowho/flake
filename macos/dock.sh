#!/usr/bin/env zsh
set -euo pipefail

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 35
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock size-immutable -bool true

defaults write com.apple.dock persistent-apps -array

add_app() {
  local app_path="$1"
  defaults write com.apple.dock persistent-apps -array-add \
    "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app_path}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

add_app "/Applications/Helium.app"
add_app "/System/Applications/Notes.app"
add_app "/System/Applications/Reminders.app"
add_app "/System/Applications/Mail.app"
add_app "/Applications/iTerm.app"
add_app "/System/Applications/Music.app"
add_app "/System/Applications/System Settings.app"
