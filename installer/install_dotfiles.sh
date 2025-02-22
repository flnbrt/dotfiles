#!/bin/bash

PACKAGE_MANAGER=""

####################
# Helper functions #
####################

# Get package manager
get_package_manager() {
    if [ $(uname) == "Darwin" ]; then
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
  echo "# Installing $package"
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

# install tools using Homebrew if not already installed
install_with_brew() {
  local tool=$1
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Installing $tool via homebrew"
  echo "#-----------------------------------------------------------------------"
  command -v $tool &>/dev/null || brew install $tool
}

# install tools using a script if not already installed
install_with_script() {
  local tool=$1
  local installer_string=$2
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Installing $tool via script"
  echo "#-----------------------------------------------------------------------"
  command -v $tool &>/dev/null || eval "$installer_string"
}

# install tools using pip if not already installed
install_with_pip() {
  local tool=$1
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Installing $tool via pip"
  echo "#-----------------------------------------------------------------------"
  command -v $tool &>/dev/null || pip3 install $tool
}

#-------------#
# Main Script #
#-------------#

get_package_manager

###########################
# change shell to zsh and #
# ask for session restart #
###########################

if ! echo "$0" | grep -q "zsh"; then
  # install zsh
  install_package "zsh"

  # Change default login shell to ZSH
  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Changing login shell"
  echo "#-----------------------------------------------------------------------"
  echo "You are currently not using the ZSH shell. Changing your default login shell now..."
  if chsh -s "$(command -v zsh)" 2>/dev/null; then
    echo "Successfully set ZSH as your new login shell."
    echo "Please restart your terminal session and run this script again!"
    echo ""
    exit 0
  else
    echo "Failed to change the login shell to ZSH. Please try again or contact your system administrator."
    exit 1
  fi
fi

########################
# Install dependencies #
########################

install_package "python3-dev python3-pip python3-setuptools"
install_package "curl"
install_package "git"
install_package "fzf"
install_package "stow"

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

###############
# Python venv #
###############

# Create Python venv on Linux if it does not exist
[[ $(uname) == "Linux" && ! -d $HOME/.python/bin ]] && python3 -m venv $HOME/.python --system-site-packages
[[ -f $HOME/.python/bin/activate ]] && source $HOME/.python/bin/activate

#############################
# Install tools via scripts #
#############################

# Homebrew setup for macOS
if [[ $(uname) == "Darwin" ]]; then
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif ! command -v brew &>/dev/null; then
    echo ""
    echo "#-----------------------------------------------------------------------"
    echo "# Installing Homebrew"
    echo "#-----------------------------------------------------------------------"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# Other tools
if [[ $(uname) == "Darwin" ]]; then
  install_with_brew "oh-my-posh"
  install_with_brew "thefuck"
  install_with_brew "zoxide"
  install_with_brew "fzf"
  install_with_brew "lazygit"
elif [[ $(uname) == "Linux" ]]; then
  install_with_script "oh-my-posh" "curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin"
  install_with_pip "thefuck"
  install_with_script "zoxide" "curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man"
  install_with_script "lazygit" "curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/installer/install_update_lazygit.sh | bash -s -- --bin-dir /usr/local/bin"
  install_with_script "lazydocker" "curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash"
fi

  echo ""
  echo "#-----------------------------------------------------------------------"
  echo "# Installation procedure complete"
  echo "#-----------------------------------------------------------------------"
  echo "The installation procedure using this script finished successfully!"
  echo "Thanks for using my script."
  echo "Please restart your terminal session to let ZSH install it's extensions."
  echo ""
  exit 0