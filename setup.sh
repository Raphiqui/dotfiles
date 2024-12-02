#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status.

# Function to install Homebrew
install_homebrew() {
  echo "Do you want to install Homebrew? (yes/no)"
  read answer
  case $answer in
    yes)
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo >> /home/norsse/.bashrc
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/norsse/.bashrc
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      ;;
    no)
      echo "Skipping Homebrew installation."
      ;;
    *)
      echo "Invalid response. Skipping Homebrew installation."
      ;;
  esac
}

# Function to install chezmoi
install_chezmoi() {
  echo "Installing chezmoi..."
  if ! command -v brew > /dev/null; then
    echo "Homebrew is not installed. Please install Homebrew first."
    exit 1
  fi
  brew install chezmoi
}

# Function to set up local configuration with chezmoi
setup_local_config() {
  echo "Please enter your GitHub username:"
  read GITHUB_USERNAME
  if [ -z "$GITHUB_USERNAME" ]; then
    echo "GitHub username cannot be empty. Exiting."
    exit 1
  fi
  chezmoi init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git
}

# Function to install Fish Shell
install_fish() {
  echo "Installing Fish Shell..."
  if [ "$(uname)" = "Linux" ]; then
    sudo apt-add-repository ppa:fish-shell/release-3 -y
    sudo apt update
    sudo apt install -y fish
  elif [ "$(uname)" = "Darwin" ]; then
    brew install fish
  fi
}

# Function to install Oh My Fish (OMF)
install_omf() {
  echo "Installing Oh My Fish (OMF)..."
  curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
}

# Function to install act
install_act() {
  echo "Installing Act..."
  if [ "$(uname)" = "Linux" ]; then
    curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
  elif [ "$(uname)" = "Darwin" ]; then
    brew install act
  fi
}

# Prompt to install Homebrew
install_homebrew

# Install chezmoi and set up local configuration
install_chezmoi
setup_local_config

# Install remaining dependencies
install_fish
install_omf
install_act

echo "Setup complete! Make sure to set Fish as your default shell if desired."
