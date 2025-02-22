# .zshrc
# Custom .zshrc for use with various extras

if [[ $(uname) == "Darwin" ]] then
  if [[ ! -f "/opt/homebrew/bin/brew" ]] then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -f "/opt/homebrew/opt/openjdk/bin/java" ]] then
  # Add OpenJDK to PATH for homebrew installations
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
fi

# Create python venv on linux if it does not exists
if [[ $(uname) == "Linux" ]] then
  if [[ ! -f $HOME/.python/bin/python3 ]] then
      # Create python venv
      python3 -m venv $HOME/.python --system-site-packages
  fi
  # source python venv
  source $HOME/.python/bin/activate
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi


# Download and install Oh-My-Posh, if it's not there yet
if [[ $(uname) == "Darwin" ]] then
  if [[ ! -f /opt/homebrew/bin/oh-my-posh ]] then
    # use homebrew
    brew install oh-my-posh
  fi
elif [[ ! -f /usr/local/bin/oh-my-posh ]] then
    # Install Oh-My-Posh using script
    curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
fi

# Download and install thefuck, if it's not there yet
if [[ $(uname) == "Darwin" ]] then
  if [[ ! -f /opt/homebrew/bin/thefuck ]] then
    # use homebrew
    brew install thefuck
  fi
elif [[ ! -f /root/.python/bin/thefuck ]] then
    # Install thefuck using pip3
    pip3 install thefuck --user
fi

# Download and install zoxide, if it's not there yet
if [[ $(uname) == "Darwin" ]] then
  if [[ ! -f /opt/homebrew/bin/zoxide ]] then
    # use homebrew
    brew install zoxide
  fi
elif [[ $(uname) == "Linux" ]] then
  if [[ ! -f /usr/local/bin/zoxide ]] then
    # Install zoxide using script
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man/
  fi
fi

# Download and install lazygit, if it's not there yet
if [[ $(uname) == "Darwin" ]] then
  if [[ ! -f /opt/homebrew/bin/lazygit ]] then
    # use homebrew
    brew install lazygit
  fi
elif [[ $(uname) == "Linux" ]] then
  if [[ ! -f /usr/local/bin/lazygit ]] then
    # Install lazygit using custom script
    cat $HOME/dotfiles/.config/lazygit/lazygit_installer.sh | bash
  fi
fi

# Download and install lazydocker, if it's not there yet
if [[ $(uname) == "Linux" ]] then
  if [[ ! -f /usr/local/bin/lazydocker ]] then
    # Install lazydocker using script
    export DIR="/usr/local/bin"
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash 
  fi
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::thefuck
zinit snippet OMZP::1password
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::terraform

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Prompt customization
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Keybindings
#bindkey -e
#bindkey '^p' history-search-backward
#bindkey '^n' history-search-forward
#bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vi='nvim'
alias vim='nvim'
alias c='clear'
alias dpsn='docker ps --format "{{.Names}}"'
alias lgit='lazygit'

# Linux only aliases
if [[ $(uname) == "Linux" ]] then
  alias zoxide-update='curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man/'
  alias z-update='curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man/'
  alias lazygit-updater='cat $HOME/dotfiles/.config/lazygit/lazygit_installer.sh | bash'
  alias lgit-updater='cat $HOME/dotfiles/.config/lazygit/lazygit_installer.sh | bash'
  alias lzd='lazydocker'
  alias lazydocker-update='curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash'
  alias lzd-update='curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash'
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval $(thefuck --alias)
