# .zshrc
# Custom .zshrc for use with various extras

#########################
# Environmental exports #
#########################

[[ $(uname) == "Linux" ]] && export DIR=/usr/local/bin

# Homebrew for macOS
if [[ $(uname) == "Darwin"]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Add OpenJDK to PATH for Homebrew installations
[[ -d "/opt/homebrew/opt/openjdk/bin" ]] && export PATH="/opt/homebrew/opt/openjdk/bin:$PATH" && export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# Create Python venv on Linux if it does not exist
[[ $(uname) == "Linux" && ! -d $HOME/.python/bin ]] && python3 -m venv $HOME/.python --system-site-packages
[[ -f $HOME/.python/bin/activate ]] && source $HOME/.python/bin/activate

# Set the directory for Zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not there yet
[[ ! -d "$ZINIT_HOME" ]] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add Zsh plugins
zinit light-mode for \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-completions \
  zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab

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
alias run-dotfiles-installer='curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/installer/install_dotfiles.sh | bash'
alias stow-dotfiles='stow . --adopt -d $HOME/dotfiles/ -t $HOME --ignore='^installer$' --verbose=2'

# Linux only aliases
[[ $(uname) == "Linux" ]] && {
  alias zoxide-update='curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man/'
  alias z-update='curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin --man-dir /usr/local/share/man/'
  alias lazygit-updater='curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/installer/install_update_lazygit.sh | bash -s -- --bin-dir /usr/local/bin'
  alias lgit-updater='curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/installer/install_update_lazygit.sh | bash -s -- --bin-dir /usr/local/bin'
  alias lzd='lazydocker'
  alias lazydocker-update='curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash'
  alias lzd-update='curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash'
}

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval $(thefuck --alias)
