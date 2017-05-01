# users generic .zshrc file for zsh(1)

autoload -Uz is-at-least

_Z_NO_RESOLVE_SYMLINKS=1
_Z_CMD=j
# GIT_PROMPT_EXECUTABLE="haskell"

if type antibody 2>&1 >/dev/null; then
  unsetopt BG_NICE
  . <(antibody init)
  antibody bundle < ~/.zsh/antibody/bundles
  if test -f /proc/version && ! (cat /proc/version | grep Microsoft >/dev/null 2>&1); then
    antibody bundle zsh-users/zsh-autosuggestions
    antibody bundle olivierverdier/zsh-git-prompt
  fi
fi

if is-at-least 4.3.10; then
  autoload -Uz add-zsh-hook
fi

bindkey -v

# zsh-autosuggestions
bindkey '^G' autosuggest-execute
bindkey '^F' autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=213'

# set terminal title including current directory # {{{
#
case "${TERM}" in
kterm*|xterm*|screen*)
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac # }}}

## ignore case for completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
            /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' cache-path ~/.zsh/cache

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
WORDCHARS=${WORDCHARS:s,/,,}

# stty erase '^H'
stty intr '^C'
stty susp '^Z'

setopt promptsubst

# completion as path after =
setopt magic_equal_subst

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd
# don't push same directory
setopt pushd_ignore_dups

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no remove postfix slash of command line
setopt noautoremoveslash

# no beep sound when complete list displayed
setopt nolistbeep

# for dir completion. added '/'
setopt auto_param_slash
# add postfix '/' to a directory if completion worked
setopt mark_dirs

setopt complete_in_word
setopt glob_complete
setopt hist_expand

unset menu_complete
setopt auto_list
setopt auto_menu

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

autoload -Uz colors
colors

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
bindkey "^r" history-incremental-search-backward

# available multibyte characters
setopt print_eight_bit
setopt no_flow_control

## Command history configuration
HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_space # not save history, starts from space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_save_nodups # remove duplicated history when save history
setopt hist_no_store # `history` command won't be saved to $HISTFILE
setopt hist_reduce_blanks # trim space when save history
setopt interactive_comments # comment after '#'
setopt share_history # share command history data
setopt inc_append_history

## Alias configuration# {{{
# expand aliases before completing
setopt complete_aliases # aliased ls needs if file/dir completions work
# _expand_alias:
zstyle ':completion:*:expand-alias:*' global true
bindkey '^y' _expand_alias

case "${OSTYPE}" in
  freebsd*|darwin*)
    alias vim="$EDITOR "$@""
    alias gvim="$EDITOR -g "$@""
    alias ls='gls -F --color'
    alias o='open'
    alias oo='open .'
    alias bb='brew'
    alias buo='brew update && brew outdated'
    alias netlisten='lsof -nP -iTCP -sTCP:LISTEN'
    alias netestab='lsof -nP -iTCP -sTCP:ESTABLISHED'
    alias -g C='|pbcopy'
    alias netestablished=netestab

    if $(which gdu 2>&1 > /dev/null); then
      alias du="$(which gdu)"
    fi
    ;;
  *)
    alias ls='ls -F --color'
    ;;
esac

alias where='command -v'

alias sl='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias ltr='ls -ltr'
alias llh='ls -lh'
alias rm='nocorrect rm'
alias df='df -h'
alias su='su -l'
alias v='vim'
alias vi='vim'
alias git='LC_ALL=en_US.UTF-8 git'
alias gi='git'
alias g='git'
alias gu='git up'
alias gl='git log'
alias pyttpd='python -m SimpleHTTPServer'
alias rbttpd='ruby -run -e httpd . -p 8000'
alias re='rbenv'
alias sortn='sort -n'

# global
alias -g K9='|xargs kill -9'
alias -g L='|$PAGER -R'

setopt complete_aliases

# }}}

## terminal configurations # {{{
#
unset LSCOLORS
case "${TERM}" in
xterm)
  export TERM=xterm-color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  # unset LANG
  # export LSCOLORS=ExFxCxdxBxegedabagacad
  # export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac # }}}

# functions # {{{
# goto parent directory
function cdup() {
  echo
  cd ..
  zle reset-prompt
}
zle -N cdup
bindkey '^\^' cdup

WHICH=which

if type peco 2>&1 >/dev/null; then
  FILTERCMD=$($WHICH peco)
elif type fzf 2>&1 >/dev/null; then
  FILTERCMD=$($WHICH fzf)
elif type percol 2>&1 >/dev/null; then
  FILTERCMD=$($WHICH percol)
fi

if [ -x ${FILTERCMD} ]; then
  F=$(readlink -f "${FILTERCMD}")
  function filter-select-history() {
    local tac
    if which tac > /dev/null; then
      tac="tac"
    else
      tac="tail -r"
    fi
    BUFFER=$(fc -nl 1 | \
      eval $tac | \
      ${F} --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
  }

  function filter-select-ctrlpvim-mru() {
    local ctrlp_mrufile=$HOME/.cache/ctrlp/mru/cache.txt
    local _file
    if [ -f "${ctrlp_mrufile}" ]; then
      _file=$(cat "${ctrlp_mrufile}" | ${F})
      if [ -n "${_file}" -a -f "${_file}" ]; then
        BUFFER="${BUFFER} ${_file}"
        CURSOR=$#BUFFER
        zle clear-screen
      fi
    fi
  }

  function filter-ssh() {
    local _khost=$(grep -o '^\S\+' ~/.ssh/known_hosts | grep -v '^|' | tr -d '[]' | tr ',' '\n' | sort)
    local _chost=$(grep '^Host ' ~/.ssh/config | sed 's/^Host //' | grep -v '\*\|?' | tr ' ' '\n' | sort)

    if [ -z "${_khost}" -a -z "${_chost}" ]; then
      return
    fi

    local _host=$(echo "${_khost}\n${_chost}" | ${F})

    if [ -z "${_host}" ]; then
      return
    fi

    if [ -n "${_host}" -a -n "${TMUX}" ]; then
      eval "tmux neww -n ${_host} 'ssh ${_host}'"
    else
      eval "ssh ${_host}"
    fi
  }

  function filter-git-branch() {
    local remote=$1
    if [ "${remote}" = "r" ]; then
      local git_opts='-r'
    fi

    if ! git status >/dev/null 2>&1; then
      echo Not a git repository
      return
    fi
    local _branch=$(git branch --no-color ${git_opts} | grep -v '\*' | ${F} --prompt "CHECKOUT>")
    BUFFER="${BUFFER} ${_branch//[[:space:]]}"
    CURSOR=$#BUFFER
    # zle clear-screen
  }

  zle -N filter-ssh
  bindkey '^q' filter-ssh

  zle -N filter-select-history
  bindkey '^r' filter-select-history

  zle -N filter-select-ctrlpvim-mru
  bindkey '^t' filter-select-ctrlpvim-mru

  zle -N filter-git-branch
  bindkey '^o' filter-git-branch
fi
# }}}

autoload zmv

# autoload predict-on
# predict-on

## Completion configuration
autoload -Uz compinit
compinit

set_prompt() {
  echo -n "%F{213}%n"
  echo -n "%{${reset_color}%}@"
  echo -n "%F{208}%m"
  echo -n "%{${reset_color}%}:"
  echo -n "%{${fg[green]}%}%~%{${reset_color}%} "
  if type git_super_status 2>&1 >/dev/null; then
    echo '$(git_super_status)'
  else
    echo
  fi
  echo -n "%% "
}

case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}%/ ${fg[green]}#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{${fg[cyan]}%}%n%{${reset_color}%}@%{${fg[yellow]}%}%m%{${reset_color}%}:${PROMPT}"

  [ -n "${SSH_CONNECTION}" ] &&
      PROMPT="%{${fg[blue]}%}%3v%{${reset_color}%}"
  ;;
*)
  PROMPT=$(set_prompt)
  PROMPT2="%{${fg[red]}%}%_%{${reset_color}%}%% "
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}"

  [ -n "${SSH_CONNECTION}" ] &&
      RPROMPT="%{${fg[blue]}%}%3v%{${reset_color}%}"

  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
      PROMPT="%{${fg[magenta]}%}%n%{${reset_color}%}@%{${fg[yellow]}%}%m%{${reset_color}%}:${PROMPT}"
  ;;
esac

if [ -x brew ]; then
  BREW_PREFIX=$(brew --prefix)

  for z in ${BREW_PREFIX}/opt/awscli/share/zsh/site-functions/_aws \
           ~/.zsh/functions/zsh-utils; do
    [ -s ${z} ] && . ${z}
  done
fi

[ -s /home/tacahiroy/.gvm/scripts/gvm  ] && source "/home/tacahiroy/.gvm/scripts/gvm"

# __END__
# vim: et ts=2 sts=2 sw=2