#!/bin/bash

set -e  # Exit on error

echo "🛠️  Starting system setup..."

# ------------------------------------------
# Step 1: Update & Install essential packages
# ------------------------------------------
echo "🔄 Updating package lists..."
sudo apt-get update -y

echo "🔧 Installing build-essential..."
sudo apt-get install -y build-essential curl file git

# ------------------------------------------
# Step 2: Create SSH Key for GitHub (if missing)
# ------------------------------------------
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  echo "🔑 Creating a new GitHub SSH key..."
  echo -n "Enter your GitHub email: "
  read email
  ssh-keygen -t ed25519 -C "$email"

  echo "🚀 SSH public key created! Add it to your GitHub account:"
  echo "----------------------------------------------------------"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo "----------------------------------------------------------"
  echo "🔗 Open GitHub -> Settings -> SSH and GPG keys -> New SSH key"
  read -p "Press enter after you've added your key to GitHub..."
else
  echo "✅ SSH key already exists! Skipping..."
fi

# ------------------------------------------
# Step 3: Install Homebrew (if not installed)
# ------------------------------------------
if ! command -v brew &> /dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Load Homebrew into the current session
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed!"
fi

echo "🩺 Running brew doctor..."
brew doctor || true

# ------------------------------------------
# Step 4: Install Chezmoi (if not installed)
# ------------------------------------------
if ! command -v chezmoi &> /dev/null; then
  echo "📦 Installing chezmoi..."
  brew install chezmoi
else
  echo "✅ chezmoi already installed!"
fi

echo "📝 Chezmoi version:"
chezmoi --version

# ------------------------------------------
# Step 5: Git Global Configuration
# ------------------------------------------
echo -n "Enter your GitHub email for Git config: "
read email
git config --global user.email "$email"

echo -n "Enter your GitHub name for Git config: "
read name
git config --global user.name "$name"

echo "✅ Git config updated:"
git config --global --list

# ------------------------------------------
# Step 6: Chezmoi Init & Apply Dotfiles
# ------------------------------------------
echo -n "Enter your GitHub username (e.g., Raphiqui): "
read -r GITHUB_USERNAME

echo "🚀 Initializing chezmoi with your dotfiles repo..."
chezmoi init --apply git@github.com:"$GITHUB_USERNAME"/dotfiles.git

echo "🎉 Setup complete!"

