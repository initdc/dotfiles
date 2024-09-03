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
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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
    wget -cqP ~/.zsh/download_temp 'https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/git/git.plugin.zsh'
}

download_files_mirror() {
    wget -cqP ~/.zsh/download_temp 'https://gh-rep.m02.link/ohmyzsh/ohmyzsh/raw/master/plugins/git/git.plugin.zsh'
}

clone_files() {
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/clone_temp/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/clone_temp/zsh-syntax-highlighting

}

clone_files_mirror() {
    git clone https://gh-rep.m02.link/zsh-users/zsh-autosuggestions.git ~/.zsh/clone_temp/zsh-autosuggestions
    git clone https://gh-rep.m02.link/zsh-users/zsh-syntax-highlighting.git ~/.zsh/clone_temp/zsh-syntax-highlighting

}

update_plugins() {
    if [ '${MIRR:-}' -ne '0' ]; then
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

if test -f ~/.zsh/git.plugin.zsh; then
    load_plugins
else
    init
fi

# https://zsh-prompt-generator.site
PROMPT='%F{green}%n%f > %B%F{cyan}%~ %f${vcs_info_msg_0_}%b'
RPROMPT='%B%F{green}%?%f%b%F{208} <<%f%F{240}%*%f'

source ~/.proxy
