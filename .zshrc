# bootstrap antidote if it doesn't exist
if [[ ! -d $ZDOTDIR/.antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote $ZDOTDIR/.antidote
fi

# source antidote
source "$ZDOTDIR/.antidote/antidote.zsh"

# initialize plugins statically
antidote load

# enable zsh completions
autoload -Uz compinit && compinit

# History
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=20000
SAVEHIST=20000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

# single letter aliases
alias c="clear"

# double letter aliases
alias vi="nvim"
alias ls="ls --color=auto"
alias la="ls -a"
alias ll="ls -l"
alias tp="trash-put"
alias wl="wezterm cli list"
alias gn="xset dpms force off"

# triple letter aliases
alias lal="ls -la"

# misc aliases
alias mkdir="mkdir -p"
alias rmdl="rm -rvf ~/Downloads/*"

# only run in wezterm terminal emulator
if [[ -n "$WEZTERM_PANE" ]]; then
  source "$WEZTERM_SHELL_INTEGRATION" 2>/dev/null

  chpwd() {
    local repo
    repo=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$repo" ]]; then
      wezterm cli set-tab-title "$(basename "$repo")" 2>/dev/null
    else
      wezterm cli set-tab-title "" 2>/dev/null
    fi
  }

  chpwd
fi

# starship init script
eval "$(starship init zsh)"


