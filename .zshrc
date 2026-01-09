# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit add-zsh-hook vcs_info
compinit

zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{yellow}✗%f'
zstyle ':vcs_info:*' stagedstr '%F{green}✗%f'
zstyle ':vcs_info:git:*' formats '%F{cyan}(%f%F{red}%b%f%F{cyan})%f%c%u '

add-zsh-hook precmd vcs_info
setopt prompt_subst

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -r ~/.dircolors ]]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

download_files() {
    curl --location --silent --show-error --continue-at - --output ~/.zsh/download_temp/git.plugin.zsh 'https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/git/git.plugin.zsh'
}

download_files_mirror() {
    curl -LsSC - -o ~/.zsh/download_temp/git.plugin.zsh 'https://ghb.moz.qzz.io/ohmyzsh/ohmyzsh/raw/master/plugins/git/git.plugin.zsh'
}

clone_files() {
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/clone_temp/zsh-autosuggestions
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/clone_temp/zsh-syntax-highlighting
}

clone_files_mirror() {
    git clone --depth 1 https://ghb.moz.qzz.io/zsh-users/zsh-autosuggestions.git ~/.zsh/clone_temp/zsh-autosuggestions
    git clone --depth 1 https://ghb.moz.qzz.io/zsh-users/zsh-syntax-highlighting.git ~/.zsh/clone_temp/zsh-syntax-highlighting
}

update_plugins() {
    if [[ $MIRR == "1" ]]; then
        clone_files_mirror
        download_files_mirror
    else
        clone_files
        download_files
    fi

    rm -rf ~/.zsh/zsh-autosuggestions ~/.zsh/zsh-syntax-highlighting
    mv ~/.zsh/clone_temp/zsh-autosuggestions ~/.zsh
    mv ~/.zsh/clone_temp/zsh-syntax-highlighting ~/.zsh

    rm ~/.zsh/git.plugin.zsh
    mv ~/.zsh/download_temp/git.plugin.zsh ~/.zsh
}

load_plugins() {
    source ~/.zsh/git.plugin.zsh
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

init() {
    mkdir -p ~/.zsh
    mkdir -p ~/.zsh/download_temp
    mkdir -p ~/.zsh/clone_temp
    update_plugins
    load_plugins
}

if [[ -r ~/.zsh/git.plugin.zsh ]]; then
    load_plugins
else
    init
fi

# https://zsh-prompt-generator.site
PROMPT='%F{green}%n%f > %B%F{cyan}%~ %f${vcs_info_msg_0_}%b'
RPROMPT='%B%F{green}%?%f%b%F{208} <<%f%F{240}%*%f'

source ~/.proxy

alias cr='crystal'
alias crr='crystal run'
alias crf='crystal tool format'

alias shd="shards"
alias shdi="shards install"
alias shdu="shards update"
alias shdr="shards run"

alias sts="sudo systemctl status"
alias sta="sudo systemctl start"
alias sre="sudo systemctl restart"
alias sto="sudo systemctl stop"
alias sen="sudo systemctl enable"
alias sdi="sudo systemctl disable"
alias slo="sudo systemctl daemon-reload"

MYPATH=(
$HOME/bin
$HOME/go/bin
$HOME/bin/truffleruby-25.0.0/bin
$HOME/bin/travis/ruby-3.4.7/bin
$HOME/bin/zig-x86_64-linux-0.15.2
$HOME/bin/zig-x86_64-linux-0.16.0-dev.747+493ad58ff
$HOME/bin/nu-0.108.0-x86_64-unknown-linux-gnu
$HOME/.local/share/pnpm
/usr/local/go/bin
)

IFS=":"
str=${MYPATH[*]}
unset IFS

case ":$PATH:" in
  *":$str:"*) ;;
  *) export PATH="$str:$PATH" ;;
esac

export GOPATH=$HOME/go
export PNPM_HOME="$HOME/.local/share/pnpm"

if command -v fnm 1> /dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi
