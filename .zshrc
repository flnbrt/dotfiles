# .zshrc
# Custom .zshrc for use with various extras

# Function to install a tool using Homebrew if not already installed
install_with_brew() {
  local tool=$1
  if ! command -v $tool &>/dev/null; then
    brew install $tool
  fi
}

# Function to install a tool using a script if not already installed
install_with_script() {
  local tool=$1
  local script_url=$2
  local bin_dir=$3
  local man_dir=$4
  if ! command -v $tool &>/dev/null; then
    if [[ -n "$man_dir" ]]; then
      curl -sSfL $script_url | bash -s -- --bin-dir $bin_dir --man-dir $man_dir
    else
      curl -sSfL $script_url | bash -s -- --bin-dir $bin_dir
    fi
  fi
}

# Function to install a tool using pip if not already installed
install_with_pip() {
  local tool=$1
  if ! command -v $tool &>/dev/null; then
    pip3 install $tool --user
  fi
}

# Homebrew setup for macOS
if [[ $(uname) == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add OpenJDK to PATH for Homebrew installations
if [[ -d "/opt/homebrew/opt/openjdk/bin" ]]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
fi

# Create Python venv on Linux if it does not exist
if [[ $(uname) == "Linux" ]]; then
  if [[ ! -d $HOME/.python/bin ]]; then
    python3 -m venv $HOME/.python --system-site-packages
  fi
  source $HOME/.python/bin/activate
fi

# Set the directory for Zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not there yet
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Install tools
if [[ $(uname) == "Darwin" ]]; then
  install_with_brew "oh-my-posh"
  install_with_brew "thefuck"
  install_with_brew "zoxide"
  install_with_brew "fzf"
  install_with_brew "lazygit"
elif [[ $(uname) == "Linux" ]]; then
  install_with_script "oh-my-posh" "https://ohmyposh.dev/install.sh" "/usr/local/bin" "/usr/local/share/man"
  install_with_pip "thefuck"
  install_with_script "zoxide" "https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh" "/usr/local/bin" "/usr/local/share/man"
  install_with_script "lazygit" "https://raw.githubusercontent.com/flnbrt/dotfiles/main/.config/lazygit/lazygit_installer.sh" "/usr/local/bin"
  install_with_script "lazydocker" "https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh" "/usr/local/bin"
fi

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add Zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add snippets
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
if [[ $(uname) == "Linux" ]]; then
  alias zoxide-update='curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man/'
  alias z-update='curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man/'
  alias lazygit-updater='curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/.config/lazygit/lazygit_installer.sh | bash -s -- --bin-dir /usr/local/bin'
  alias lgit-updater='curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/.config/lazygit/lazygit_installer.sh | bash -s -- --bin-dir /usr/local/bin'
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
