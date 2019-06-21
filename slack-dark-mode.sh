#!/usr/bin/env bash

# Homebaked Slack Dark Mode. After executing this script, hit refresh (⌘ + R) or restart Slack for changes to take effect.
# Adopted from https://gist.github.com/a7madgamal/c2ce04dde8520f426005e5ed28da8608

OSX_SLACK_RESOURCES_DIR="/Applications/Slack.app/Contents/Resources"
LINUX_SLACK_RESOURCES_DIR="/usr/lib/slack/resources"
UPDATE_ONLY="false"

if [[ -d $OSX_SLACK_RESOURCES_DIR ]]; then SLACK_RESOURCES_DIR=$OSX_SLACK_RESOURCES_DIR; fi
if [[ -d $LINUX_SLACK_RESOURCES_DIR ]]; then SLACK_RESOURCES_DIR=$LINUX_SLACK_RESOURCES_DIR; fi
if [[ "$1" == "-u" ]]; then UPDATE_ONLY="true"; fi

SLACK_EVENT_LISTENER="event-listener.js"
SLACK_FILEPATH="$SLACK_RESOURCES_DIR/app.asar.unpacked/src/static/ssb-interop.js"
THEME_FILEPATH="$SLACK_RESOURCES_DIR/dark-theme.css"

#curl -sSL -o "$THEME_FILEPATH" "https://cdn.rawgit.com/laCour/slack-night-mode/master/css/raw/black.css"

if [[ "$UPDATE_ONLY" == "true" ]]; then
  echo && echo "Updating Dark Theme Code to Slack... "
else
  echo && echo "Adding Dark Theme Code to Slack... "
fi

echo "This script requires sudo privileges."
echo "You'll need to provide your password."
sudo cp -af dark-theme.css "$THEME_FILEPATH"

if [[ "$UPDATE_ONLY" == "true" ]]; then
  echo && echo "Updating Dark Theme Code to Slack... "
else
  echo && echo "Adding Dark Theme Code to Slack... "
  sudo tee -a "$SLACK_FILEPATH" < $SLACK_EVENT_LISTENER
fi

sudo sed -i -e s@SLACK_DARK_THEME_PATH@$THEME_FILEPATH@g $SLACK_FILEPATH

echo && echo "Done! After executing this script, hit refresh (⌘ + R) or restart Slack for changes to take effect."
