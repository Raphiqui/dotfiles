#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

sudo apt-get update
sudo apt install -y build-essential

# Detect if running in CI/CD (GitHub Actions sets this environment variable)
if [ -n "$CI" ]; then
  echo "Running in CI/CD mode: Auto-accepting all prompts and skipping GitHub linking."
  AUTO_ACCEPT="yes"
else
  AUTO_ACCEPT="no"
fi

# Function to install Homebrew
install_homebrew() {
  echo "Do you want to install Homebrew? (yes/no)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    answer="yes"
  else
    read answer
  fi
  case $answer in
    yes)
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo >> /home/norsse/.bashrc
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/norsse/.bashrc
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      source "$HOME/.bashrc"
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
  echo "Do you want to install chezmoi? (y/n)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    response="y"
  else
    read -r response
  fi
  if [ "$response" = "y" ]; then
    echo "Installing chezmoi..."
    brew install chezmoi
  else
    echo "Skipping chezmoi installation."
  fi
}

# Function to set up local configuration with chezmoi
setup_local_config() {
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    echo "Skipping GitHub setup in CI/CD environment."
    return
  fi
  echo "Do you want to set up local configuration with chezmoi? (y/n)"
  read -r response
  if [ "$response" = "y" ]; then
    echo "Please enter your GitHub username:"
    read -r GITHUB_USERNAME
    if [ -z "$GITHUB_USERNAME" ]; then
      echo "GitHub username cannot be empty. Exiting."
      exit 1
    fi
    chezmoi init --apply git@github.com:"$GITHUB_USERNAME"/dotfiles.git
  else
    echo "Skipping local configuration setup."
  fi
}

# Function to install Fish Shell
install_fish() {
  echo "Do you want to install Fish Shell? (y/n)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    response="y"
  else
    read -r response
  fi
  if [ "$response" = "y" ]; then
    echo "Installing Fish Shell..."
    if [ "$(uname)" = "Linux" ]; then
      sudo apt-add-repository ppa:fish-shell/release-3 -y
      sudo apt update
      sudo apt install -y fish
    elif [ "$(uname)" = "Darwin" ]; then
      brew install fish
    fi
  else
    echo "Skipping Fish Shell installation."
  fi
}

# Function to install Oh My Fish (OMF)
install_omf() {
  echo "Do you want to install Oh My Fish (OMF)? (y/n)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    response="y"
  else
    read -r response
  fi
  if [ "$response" = "y" ]; then
    echo "Installing Oh My Fish (OMF)..."
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
  else
    echo "Skipping Oh My Fish (OMF) installation."
  fi
}

# Function to install pyenv
install_pyenv() {
  echo "Do you want to install pyenv? (y/n)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    response="y"
  else
    read -r response
  fi
  if [ "$response" = "y" ]; then
    echo "Installing pyenv..."
    curl https://pyenv.run | bash
    echo 'set -x PYENV_ROOT $HOME/.pyenv' >> ~/.config/fish/config.fish
    echo 'set -x PATH $PYENV_ROOT/bin $PATH' >> ~/.config/fish/config.fish
    echo 'status --is-interactive; and pyenv init --path | source' >> ~/.config/fish/config.fish
    echo 'status --is-interactive; and pyenv init - | source' >> ~/.config/fish/config.fish
    echo 'status --is-interactive; and pyenv virtualenv-init - | source' >> ~/.config/fish/config.fish
  else
    echo "Skipping pyenv installation."
  fi
}

# Function to install Neovim
install_neovim() {
  echo "Do you want to install Neovim? (y/n)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    response="y"
  else
    read -r response
  fi
  if [ "$response" = "y" ]; then
    echo "Installing Neovim..."
    if [ "$(uname)" = "Linux" ]; then
      sudo apt install -y neovim
    elif [ "$(uname)" = "Darwin" ]; then
      brew install neovim
    fi
  else
    echo "Skipping Neovim installation."
  fi
}

# Prompt to install Homebrew
install_homebrew

# Install chezmoi and set up local configuration
install_chezmoi
setup_local_config

# Install remaining dependencies
install_pyenv # pyenv comes first because fish and omf are configured with it
install_fish
install_omf
install_neovim

echo "Setup complete! Make sure to set Fish as your default shell if desired."
