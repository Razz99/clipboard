#!/bin/bash

# Get the current user's username
USERNAME=$(whoami)

# Define the destination directory (desktop of the current user)
DESTINATION="/Users/$USERNAME"

# URL of the GitHub repository
REPO_URL="https://github.com/Razz99/clipboard.git"

# Alias command to add to .zshrc
ALIAS_COMMAND="alias clip='swift $DESTINATION/clipboard/clipboard_v2.swift"

# Check if the destination directory exists
if [ ! -d "$DESTINATION" ]; then
  echo "Error: User/$USERNAME Directory for user $USERNAME does not exist."
  exit 1
fi

# Change directory to the user's desktop
cd "$DESTINATION" || exit 1

# Clone the repository
git clone "$REPO_URL"

# Check if the clone was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to clone the repository."
  exit 1
fi

# Add the alias command to the system-wide .zshrc
if [ "$(id -u)" -eq 0 ]; then
  ZSHRC_FILE="/etc/zsh/zshrc"
else
  ZSHRC_FILE="/etc/zsh/zshrc"
fi

echo "$ALIAS_COMMAND" >> "$ZSHRC_FILE"

# Inform the user about the added alias
echo "New Clipboard for your MAC is ready to use. Type clip in your terminal and it is ready to remember everything you copied. Recommended to use with oh-my-zsh terminal."
