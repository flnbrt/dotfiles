#!/bin/bash

PACKAGE_MANAGER=""

####################
# Helper functions #
####################

# setup package manager
setup_package_manager() {
    if [ $(uname) == "Darwin" ]; then
      PACKAGE_MANAGER="brew upgrade"
    else
      if command -v apt &>/dev/null; then
          PACKAGE_MANAGER="apt upgrade -y"
          eval "sudo apt update"
      elif command -v dnf &>/dev/null; then
          PACKAGE_MANAGER="dnf upgrade -y"
      elif command -v yum &>/dev/null; then
          PACKAGE_MANAGER="yum upgrade -y"
      elif command -v zypper &>/dev/null; then
          PACKAGE_MANAGER="zypper update -y"
      elif command -v pacman &>/dev/null; then
          PACKAGE_MANAGER="pacman -S --noconfirm"
      else
          echo "Could not determine a supported package manager. Aborting..."
          exit 1
      fi
    fi
}

# update dependency
update_package() {
  local package=$1
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Updating $package"
  echo "#-----------------------------------------------------------------------"
  if [[ "$package" == "fzf" && "$(uname)" != "Darwin" ]]; then
    eval "git -C $HOME/.fzf pull"
    eval "$HOME/.fzf/install --key-bindings --completion --no-update-rc"
  else
    eval "$PACKAGE_MANAGER $package"
  fi
}

# stow config files
stow_files() {
  # double check if dotfiles really need to get stowed...
  if ! grep -q "# Custom .zshrc for use with various extras" "$HOME/.zshrc" &>/dev/null; then
    echo "Stowing files..."
    stow . --adopt -d "$HOME/dotfiles/" -t "$HOME" --ignore='^(installer|windows)$' --verbose=2
    git -C $HOME/dotfiles reset --hard &>/dev/null
  fi
}

# update tools using Homebrew
update_with_brew() {
  local tool=$1
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Updating $tool via homebrew"
  echo "#-----------------------------------------------------------------------"
  eval "brew upgrade $tool"
}

# update tools using a script
update_with_script() {
  local tool=$1
  local installer_string=$2
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Updating $tool via script"
  echo "#-----------------------------------------------------------------------"
  eval "$installer_string"
}

# update tools using pip
update_with_pip() {
  local tool=$1
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Updating $tool via pip"
  echo "#-----------------------------------------------------------------------"
  eval "pip3 install --upgrade $tool"
}

#-------------#
# Main Script #
#-------------#

setup_package_manager

#######################
# Update dependencies #
#######################

update_package "zsh"
update_package "python3-dev python3-pip python3-setuptools"
update_package "curl"
update_package "git"
update_package "fzf"
update_package "stow"
update_package "vim neovim"
update_package "eza"
update_package "bat"
update_package "ripgrep"
update_package "fd"

################################
# Pulling of GitHub repository #
################################

echo ""
echo "#-----------------------------------------------------------------------"
echo "# Pulling GitHub repository in ${HOME}/dotfiles"
echo "#-----------------------------------------------------------------------"
if git -C $HOME/dotfiles pull; then
    echo "Successfully pulled GitHub repository in ${HOME}/dotfiles."
else
    echo "Error during pulling of GitHub repository in ${HOME}/dotfiles."
    echo "Aborting."
    exit 1
fi

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
    stow . --adopt -d "$HOME/dotfiles/" -t "$HOME" --ignore='^(installer|windows)$' --verbose=2
    exit 1
  fi
fi

###############
# Python venv #
###############

# Create Python venv on Linux if it does not exist
[[ $(uname) == "Linux" && ! -d $HOME/.python/bin ]] && python3 -m venv $HOME/.python --system-site-packages
[[ -f $HOME/.python/bin/activate ]] && source $HOME/.python/bin/activate

############################
# Update tools via scripts #
############################

# Other tools
if [[ $(uname) == "Darwin" ]]; then
  update_with_brew "oh-my-posh"
  update_with_brew "thefuck"
  update_with_brew "zoxide"
  update_with_brew "fzf"
  update_with_brew "lazygit"
elif [[ $(uname) == "Linux" ]]; then
  update_with_script "oh-my-posh" "curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin"
  update_with_pip "thefuck"
  update_with_script "zoxide" "curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man"
  update_with_script "lazygit" "curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/installer/install_update_lazygit.sh | bash -s -- --bin-dir /usr/local/bin"
  update_with_script "lazydocker" "curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash"
fi

echo ""
echo "#-----------------------------------------------------------------------"
echo "# Update procedure complete"
echo "#-----------------------------------------------------------------------"
echo "The update procedure using this script finished successfully!"
echo "Thanks for using my script."
echo ""
exit 0
