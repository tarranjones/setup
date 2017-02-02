# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo xcodebuild -license accept

install_application $PLATFORM_APPLICATIONS_DIR/brew

install_application $APPLICATIONS_DIR/node

npm install --global macos-setup-defaults-cli

macos-setup-defaults defaults-write.json

npm remove --global macos-setup-defaults-cli

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
