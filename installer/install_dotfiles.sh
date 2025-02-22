#!/bin/bash

####################
# Helper functions #
####################

# Get package manager
get_package_manager() {
    if uname == "Darwin"; then
      PACKAGE_MANAGER="brew install "
    else
      if command -v apt &>/dev/null; then
          PACKAGE_MANAGER="apt install -y"
      elif command -v dnf &>/dev/null; then
          PACKAGE_MANAGER="dnf install -y"
      elif command -v yum &>/dev/null; then
          PACKAGE_MANAGER="yum install -y"
      elif command -v zypper &>/dev/null; then
          PACKAGE_MANAGER="zypper install -y"
      elif command -v pacman &>/dev/null; then
          PACKAGE_MANAGER="pacman -S --noconfirm"
      else
          echo "Could not determine a supported package manager. Aborting..."
          exit 1
      fi
    fi
}

# install dependency
install_package() {
  local package=$1
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Installing $1"
  echo "#-----------------------------------------------------------------------"
  eval "$PACKAGE_MANAGER $package"
}

# stow config files
stow_files() {
  # double check if dotfiles really need to get stowed...
  if ! grep -q "# Custom .zshrc for use with various extras" "$HOME/.zshrc" &>/dev/null; then
    echo "Stowing files..."
    stow . --adopt -d $HOME/dotfiles/ -t $HOME --ignore='^installer$'
    git -C $HOME/dotfiles reset --hard &>/dev/null
  fi
}

#-------------#
# Main Script #
#-------------#

get_package_manager

################################
# Cloning of GitHub repository #
################################

if [ ! -d "$HOME/dotfiles" ]; then
    echo ""
    echo "#-----------------------------------------------------------------------"
    echo "# Cloning GitHub repository to ${HOME}/dotfiles"
    echo "#-----------------------------------------------------------------------"
    if git clone https://github.com/flnbrt/dotfiles.git $HOME/dotfiles; then
        echo "Successfully cloned GitHub repository to ${HOME}/dotfiles."
    else
        echo "Error during cloning of GitHub repository to ${HOME}/dotfiles."
        echo "Aborting."
        exit 1
    fi
fi

########################
# Install dependencies #
########################

install_package "python3-dev python3-pip python3-setuptools"
install_package "curl"
install_package "git"
install_package "zsh"
install_package "fzf"
install_package "stow"

#################
# Stowing files #
#################

# Check if files need to get stowed
if [ ! -L "$HOME/.zshrc" ]; then
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Stowing Dotfiles"
  echo "#-----------------------------------------------------------------------"
  echo "Configuration for dotfiles isn't complete!"
  echo "Stowing dotfiles now..."
  if stow_files; then
    echo "Successfully stowed all dotfiles."
  else
    echo "stow command failed. Please stow dotfiles manually."
    exit 1
  fi
fi

# Change shell to ZSH
if ! echo "$SHELL" | grep -q "zsh"; then
  echo "#-----------------------------------------------------------------------"
  echo "# Changing login shell"
  echo "#-----------------------------------------------------------------------"
  echo "You are currently not using the ZSH shell. Changing your default login shell now..."
  if chsh -s "$(command -v zsh)" 2>/dev/null; then
    echo "Successfully set ZSH as your new login shell. Please restart your current session."
  else
    echo "Failed to change the login shell to ZSH. Please try again or contact your system administrator."
  fi
fi