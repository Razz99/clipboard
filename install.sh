#!/bin/bash

# Get the current user's username
USERNAME=$(whoami)

# Define the destination directory (desktop of the current user)
DESTINATION="/Users/$USERNAME"

# URL of the GitHub repository
REPO_URL="https://github.com/Razz99/clipboard.git"

# Alias command to add to .zshrc
ALIAS_COMMAND="alias clip='swift $DESTINATION/clipboard/clipboard_v2.swift'"

# Prompt the user for the path to the .zshrc file
echo "Please enter the path to your .zshrc file\n(Most of the time path would be ==> /Users/$USERNAME/.zshrc)"
read ZSHRC_PATH

# Check if the specified .zshrc file exists
if [ ! -f "$ZSHRC_PATH" ]; then
  echo "Error: .zshrc file does not exist in the specified path."
  exit 1
fi

# Change directory to the user's desktop
cd "$DESTINATION" || exit 1

# Check if the repository directory already exists, and if so, delete it
if [ -d "clipboard" ]; then
  rm -rf "clipboard"
fi

# Clone the repository with a spinner animation
echo "Installing........"
git clone --quiet "$REPO_URL"

# Check if the clone was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to clone the repository."
  exit 1
fi

# Add the alias command to the specified .zshrc file
echo "$ALIAS_COMMAND" >> "$ZSHRC_PATH"
echo "Done!"

# Inform the user about the added alias
echo "\n\nNew Clipboard for your MAC is ready to use. Type 'clip' in your terminal, and it is ready to remember everything you copied. Recommended to use with oh-my-zsh terminal."
