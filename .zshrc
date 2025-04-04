# .zshrc
# Custom .zshrc for use with various extras

#########################
# Environmental exports #
#########################

[[ $(uname) == "Linux" ]] && export DIR=/usr/local/bin

# Homebrew for macOS
[[ $(uname) == "Darwin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

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

# Plugins
zinit wait lucid light-mode for \
  Aloxaf/fzf-tab \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-autosuggestions \
  fdellwing/zsh-bat

zinit for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions

# Snippets
zinit ice wait lucid
zinit for \
  OMZP::git \
  OMZP::sudo \
  OMZP::kubectl \
  OMZP::command-not-found \
  OMZP::thefuck \
  OMZP::1password \
  OMZP::docker \
  OMZP::docker-compose \
  OMZP::terraform

# Load completions
#- commented out because we don't need it anymore -#
#autoload -Uz compinit && compinit
#zinit cdreplay -q

# Prompt customization
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Keybindings
bindkey -M emacs '^^' sudo-command-line
bindkey -M vicmd '^^' sudo-command-line
bindkey -M viins '^^' sudo-command-line

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
setopt globdots

# Aliases
alias ls='eza --icons=always'
alias l='eza -la --icons=always'
alias ll='eza -la -snew --icons=always'
alias vi='nvim'
alias vim='nvim'
alias c='clear'
alias dpsn='docker ps --format "{{.Names}}"'
alias lg='lazygit'
alias lgit='lazygit'
alias run-dotfiles-installer='curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/installer/install_dotfiles.sh | bash'
alias run-dotfiles-updater='curl -sSfL https://raw.githubusercontent.com/flnbrt/dotfiles/main/installer/update_dotfiles.sh | bash'
alias stow-dotfiles='stow . --adopt -d $HOME/dotfiles/ -t $HOME --ignore="^(installer|windows)$" --verbose=2'
alias df='df -Ph | grep -v overlay | grep -v loop'

# Linux only aliases
[[ $(uname) == "Linux" ]] && {
  alias ldocker='lazydocker'
  alias lzd='lazydocker'
  alias ld='lazydocker'
  alias docker_useradd='useradd --no-create-home --no-user-group --shell /usr/sbin/nologin --home-dir /root/docker --groups docker_data --uid'
}

# macOS only aliases
[[ $(uname) == "Darwin" ]] && { 
  alias brewuu='brew update && brew upgrade'
}

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval $(thefuck --alias)

