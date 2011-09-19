#
#To include this file add the following line to ~/.bashrc
# . "/Users/brian/env.git/bashrc" 
#
# On Mac also make sure the following is in ~/.bash_profile
#if [ -f ~/.bashrc ]; then
#  . ~/.bashrc
#fi


alias ls='ls -G'
alias lsd='ls -aFh --color --group-directories-first'
alias cp='cp -i'
alias df='df -h'
alias du='du -h'
alias mv='mv -i'
alias rm='rm -i'
alias less='less -R'

alias git-netbook='git pull --tags netbook working'
alias git-desktop='git pull --all --tags'
alias sshhome='ssh bcmilco.homelinux.org -p 2222'

HISTSIZE=5000
PATH="~/bin:~/env.git/bin:$PATH"
EDITOR="/usr/bin/vim"

function parse_git_output {

    first=$(git config --global color.ui false 2> /dev/null)
    output=$(git status 2> /dev/null | ~/bin/git.awk 2> /dev/null) || return
    first=$(git config --global color.ui true 2> /dev/null)
    echo -e "$output";
}

GREEN="\[\033[00;32m\]"
BRIGHT_GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
CYAN="\[\033[01;36m\]"
YELLOW="\[\033[00;33m\]"
BRIGHT_YELLOW="\[\033[01;33m\]"
BRIGHT_RED="\[\033[01;31m\]"
BRIGHT_BLACK="\[\033[01;30m\]"
WHITE="\[\033[01;37m\]"
ENDCOLOR="\e[m"

if [ "$SSH_CONNECTION" == "" ]; then
    PS1="\$(parse_git_output)\n${BRIGHT_RED}≺${GREEN}\h ${BLUE}\w${BRIGHT_RED}≻$ENDCOLOR "
else
    PS1="\$(parse_git_output)\n${BRIGHT_RED}≺${YELLOW}\h ${BLUE}\w${BRIGHT_RED}≻$ENDCOLOR "
fi

export PATH EDITOR HISTSIZE

