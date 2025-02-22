# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Function to install python3
install_python3() {
  if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y python3-dev python3-pip python3-setuptools
  elif command -v yum &>/dev/null; then
    sudo yum install -y python3-dev python3-pip python3-setuptools
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y python3-dev python3-pip python3-setuptools
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm python3-dev python3-pip python3-setuptools
  elif command -v zypper &>/dev/null; then
    sudo zypper install -y python3-dev python3-pip python3-setuptools
  else
    echo "No supported package manager found. Please install python3 manually."
    return 1
  fi
}

# Function to install ZSH
install_zsh() {
  if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y zsh
  elif command -v yum &>/dev/null; then
    sudo yum install -y zsh
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y zsh
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm zsh
  elif command -v brew &>/dev/null; then
    brew install zsh
  elif command -v zypper &>/dev/null; then
    sudo zypper install -y zsh
  else
    echo "No supported package manager found. Please install ZSH manually."
    return 1
  fi
}

# Function to install stow
install_stow() {
  if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y stow
  elif command -v yum &>/dev/null; then
    sudo yum install -y stow
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y stow
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm stow
  elif command -v brew &>/dev/null; then
    brew install stow
  elif command -v zypper &>/dev/null; then
    sudo zypper install -y stow
  else
    echo "No supported package manager found. Please install stow manually."
    return 1
  fi
}

# Function to stow all config files
stow_files() {
  # double check if dotfiles really need to get stowed...
  if ! grep -q "# Custom .zshrc for use with various extras" "$HOME/.zshrc" &>/dev/null; then
    echo "Stowing files..."
    stow . --adopt -d $HOME/dotfiles/ -t $HOME
    git -C $HOME/dotfiles reset --hard &>/dev/null
  fi
}

# Check if python3 is installed
if ! command -v python3 &>/dev/null; then
  echo "Python3 is not installed. Installing python3 now..."
  if install_python3; then
    echo "Python3 installation completed."
  else
    echo "Python3 installation failed. Please install python3 manually."
  fi
fi

# Check if ZSH is installed
if ! command -v zsh &>/dev/null; then
  echo "ZSH is not installed. Installing ZSH now..."
  if install_zsh; then
    echo "ZSH installation completed."
  else
    echo "ZSH installation failed. Please install ZSH manually."
  fi
fi

# Check if stow is installed
if ! command -v stow &>/dev/null; then
  echo "stow is not installed. Installing stow now..."
  if install_stow; then
    echo "stow installation completed."
  else
    echo "stow installation failed. Please install stow manually."
  fi
fi

# Check if files need to get stowed
if [ ! -L "$HOME/.zshrc" ]; then
  echo "Configuration for dotfiles isn't complete!"
  echo "Stowing dotfiles now..."
  if stow_files; then
    echo "Successfully stowed all dotfiles."
  else
    echo "stow command failed. Please stow dotfiles manually."
  fi
fi

# Change shell to ZSH
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "You are currently not using the ZSH shell. Changing your default login shell now..."
  if chsh -s "$(command -v zsh)" 2>/dev/null; then
    echo "Successfully set ZSH as your new login shell. Please restart your current session."
  else
    echo "Failed to change the login shell to ZSH. Please try again or contact your system administrator."
  fi
fi
