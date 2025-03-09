#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

sudo apt-get update
sudo apt install -y build-essential

# Detect if running in CI/CD (GitHub Actions sets this environment variable)
if [ -n "$CI" ]; then
  echo "Running in CI/CD mode: Auto-accepting all prompts and skipping GitHub linking."
  AUTO_ACCEPT="yes"
else
  AUTO_ACCEPT="no"
fi

configure_git() {
  # Basically to avoid avoing issues when pushing for the first time from a fresh install
  echo "Do you want to configure git? (y/n)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    echo "Skipping GitHub setup in CI/CD environment."
    return
  fi
  read answer
  if [ "$answer" = "y" ]; then
    echo "Configuring git..."
    echo "Enter your email"
    read email
    git config --global user.email "$email"
    echo "Enter your name"
    read name
    git config --global user.name "$name"
  else
    echo "Skipping git configuration."
  fi
}

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
    echo >>"$HOME/.bashrc"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.bashrc"
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
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    echo "Skipping GitHub setup in CI/CD environment."
    return
  fi
  echo "Do you want to install Oh My Fish (OMF)? (y/n)"
  read -r response
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

    # Ensure Fish configuration directory exists before writing to config.fish
    mkdir -p "$HOME/.config/fish"

    echo 'set -x PYENV_ROOT $HOME/.pyenv' >>~/.config/fish/config.fish
    echo 'set -x PATH $PYENV_ROOT/bin $PATH' >>~/.config/fish/config.fish
    echo 'status --is-interactive; and pyenv init --path | source' >>~/.config/fish/config.fish
    echo 'status --is-interactive; and pyenv init - | source' >>~/.config/fish/config.fish
    echo 'status --is-interactive; and pyenv virtualenv-init - | source' >>~/.config/fish/config.fish
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
    mkdir -p ~/.local
    curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz -o /tmp/nvim-nightly.tar.gz

    tar -xzvf /tmp/nvim-nightly.tar.gz -C ~/.local
    mv ~/.local/nvim-linux-x86_64 ~/.local/nvim

    export PATH="$HOME/.local/nvim/bin:$PATH"

    echo 'set -x PATH $HOME/.local/nvim/bin $PATH' >>~/.config/fish/config.fish
    echo 'export PATH="$HOME/.local/nvim/bin:$PATH"' >>~/.bashrc

    if command -v nvim >/dev/null 2>&1; then
      echo "Neovim nightly installed successfully!"
      nvim --version
    else
      echo "Neovim installation failed."
      exit 1
    fi
  else
    echo "Skipping Neovim installation."
  fi
}

install_minikube() {
  echo "Do you want to install minikube? (y/n)"
  if [ "$AUTO_ACCEPT" = "yes" ]; then
    response="y"
  else
    read -r response
  fi
  if [ "$response" = "y" ]; then
    echo "Installing minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
  else
    echo "Skipping minikube installation."
  fi
}

# Prompt to install Homebrew
install_homebrew

configure_git
# Install chezmoi and set up local configuration
install_chezmoi
setup_local_config

# Install remaining dependencies
install_fish
install_pyenv # pyenv comes first because fish and omf are configured with it
install_neovim
install_omf # keep this one at the end because otherwise will stop the script execution

install_minikube

echo "Setup complete! Make sure to set Fish as your default shell if desired."
