

sudo xcodebuild -license accept

recursive_install $OS_APP_DIR/brew

recursive_install $APP_DIR/node

# npm install --global macos-defaults-setup@latest
# macos-defaults-setup ../defaults-write.json
# npm remove --global macos-defaults-setup-cli

# sudo pmset
# sudo nvram
# sudo systemsetup -setrestartfreeze on


# Stop iTunes from responding to the keyboard media keys
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null


###############################################################################
# Kill affected applications                                                  #
###############################################################################

# for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#   "Dock" "Finder" "Google Chrome" "Google Chrome Canary" "Mail" "Messages" \
#   "Opera" "Safari" "SizeUp" "Spectacle" "SystemUIServer" "Terminal" \
#   "Transmission" "Twitter" "iCal"; do
#   killall "${app}" > /dev/null 2>&1
# done
# echo "Done. Note that some of these changes require a logout/restart to take effect."
