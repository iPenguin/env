#!/bin/bash
#To include this file add the following line to ~/.bashrc
# . "/Users/brian/env.git/bashrc" 
#
# On Mac also make sure the following is in ~/.bash_profile
#if [ -f ~/.bashrc ]; then
#  . ~/.bashrc
#fi

#NOTE: remove all empty directories below the current dir:
#find -depth -type d -empty -exec rmdir {} \;

#Mac color ls:
#alias ls='ls -G'
#linux
#alias ls='ls -aFh --color'

#
#use glances instead of top

export COPY_EXTENDED_ATTRIBUTES_DISABLE=true

alias lsd='ls -aFh --color --group-directories-first'
alias cp='cp -i'
alias df='df -h'
alias du='du -h'
alias mv='mv -i'
alias rm='rm -i'
alias less='less -R'
alias grep='grep --color'
alias ping6='ping6 -n'

alias ro.lan='ssh -t -i ~/.ssh/ro.lan_rsa root@ro.lan -p2220'
alias sshhome='ssh -i ~/.ssh/brian_rsa brian@bcmilco.homelinux.org -p 2222'

alias make='make -j4'
#alias top='htop'

# Colorized man pages, from:
# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
man() {
        env \
                LESS_TERMCAP_md=$(printf "\e[1;36m") \
                LESS_TERMCAP_me=$(printf "\e[0m") \
                LESS_TERMCAP_se=$(printf "\e[0m") \
                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
                LESS_TERMCAP_ue=$(printf "\e[0m") \
                LESS_TERMCAP_us=$(printf "\e[1;32m") \
                man "$@"
}


alias bigdirs='du --max-depth=1 2> /dev/null | sort -n -r | head -n20'


# Where is a function defined?
whichfunc() {
        whence -v $1
        type -a $1
}


HISTSIZE=5000
PATH="$HOME/bin:$HOME/env/bin:$PATH:/sbin:/usr/sbin:/usr/local/sbin"
EDITOR="/usr/bin/vim"

# • ❨ ❩ ⬆ ⬇ ⑈ ⑉ ǁ ║ ⑆ ⑇ ⟅ ⟆ ⬅ ➤ ➥ ➦ ➡
SEP="║"
SEP2="•"

function parse_git_output {
    path=$(pwd)
    # Don't do git status over networked paths. 
    # It kills performance, and the prompt takes forever to return.
    if [[ $path =~ "/net/" ]]; then
        return
    fi
    output=$(git status -sb --porcelain 2> /dev/null | git.awk -v separator=$SEP separator2=$SEP2 2> /dev/null) || return
    echo -e "$output"
}

BLACK="\[\e[00;30m\]"
DARK_GRAY="\[\e[01;30m\]"
RED="\[\e[00;31m\]"
BRIGHT_RED="\[\e[01;31m\]"
GREEN="\[\e[00;32m\]"
BRIGHT_GREEN="\[\e[01;32m\]"
BROWN="\[\e[00;33m\]"
YELLOW="\[\e[01;33m\]"
BLUE="\[\e[00;34m\]"
BRIGHT_BLUE="\[\e[01;34m\]"
PURPLE="\[\e[00;35m\]"
LIGHT_PURPLE="\[\e[01;35m\]"
CYAN="\[\e[00;36m\]"
BRIGHT_CYAN="\[\e[01;36m\]"
LIGHT_GRAY="\[\e[00;37m\]"
WHITE="\[\e[01;37m\]"
ENDC="\e[m"


if [ "$SSH_CONNECTION" == "" ]; then
    HCOLOR="$GREEN"
else
    HCOLOR="$YELLO"
fi

PS1="${BRIGHT_RED}#--[ ${HCOLOR}\h ${DARK_GRAY}${SEP} ${BRIGHT_BLUE}\w \$(parse_git_output)${BRIGHT_RED}]\\$ --≻${ENDC}\n"

export PATH EDITOR HISTSIZE

