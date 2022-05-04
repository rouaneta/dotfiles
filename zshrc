ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one:
#   https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful plugins for Rails development
plugins=(git git-patch gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search)

# Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# Load rbenv if installed
export PATH="${HOME}/.rbenv/bin:${PATH}"
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BUNDLER_EDITOR="'/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' -a"

# Haskell's commands
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Postgres
export PATH=/usr/local/opt/postgresql@11/bin:$PATH

# Base bin
export PATH=/Users/arthurrouanet/bin:$PATH

# Alfred CLI
export PATH=/Users/arthurrouanet/go/bin:$PATH

# FZF
export FZF_DEFAULT_OPTS="--exact --height 80% --reverse"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load Git completion
zstyle ':completion:*:*:git:*' script /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit

_decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'='
  fi
  echo "$result" | tr '_-' '/+' | base64 -d
}

# $1 => JWT to decode
# $2 => either 1 for header or 2 for body (default is 2)
decode_jwt() { _decode_base64_url $(echo -n $1 | cut -d "." -f ${2:-2}) | jq .; }
decode_jwtp() { decode_jwt "$(pbpaste)" }

# fbr - checkout git branch, sorted by most recent commit, limit 30 occurences
fbr() {
  local branches
  local branch
  local target

  branches="$(
    git for-each-ref \
      --count=30 \
      --sort=-committerdate \
      refs/heads/ \
      --format='%(refname:short)'
  )" || return

  branch="$(
    echo "$branches" \
      | fzf-tmux +m
  )" || return

  target="$(
    echo "$branch" \
      | sed "s/.* //" \
      | sed "s#remotes/[^/]*/##"
  )" || return

  git checkout "$target"
}

fbrp() {
  local branches
  local branch

  branches="$(
    git for-each-ref \
      --count=30 \
      --sort=-committerdate \
      refs/heads/ \
      --format='%(refname:short)'
  )" || return

  branch="$(
    echo "$branches" \
      | fzf-tmux +m
  )" || return

  echo $branch
}

# beautiful diff with fzf
function gdd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

# export PATH="/usr/local/bin/rubocop-daemon-wrapper:$PATH"
# export RUBOCOP_DAEMON_USE_BUNDLER=true

export GITHUB_NPM_TOKEN=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

# iterm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source ~/.iterm2_shell_integration.zsh

# iterm2 tab naming
DISABLE_AUTO_TITLE="true"
tab_title() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}
add-zsh-hook precmd tab_title

# export LOKALISE_API_TOKEN=fbc09fcb87588386dbaff07a4a6899efe3dd3e09
export LOKALISE_API_TOKEN=15bd279ef5f6ca21308aac6274edd238d27baa8e

