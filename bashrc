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

alias ro.lan='ssh -t -i ~/.ssh/ro.lan_rsa root@ro.lan -p2220'

alias add='git add'
alias status='git status'
alias tag='git tag'
alias gd='git diff'
alias ver='git describe'
alias commit='git commit'
alias push='git push'
alias pull='git pull'
alias checkout='git checkout'

alias sftpsws='sftp -i ~/.ssh/StitchWorksSoftware_dsa stitchw1@stitchworkssoftware.com'
alias sshsws='ssh -i ~/.ssh/StitchWorksSoftware_dsa stitchw1@stitchworkssoftware.com'
alias sshhome='ssh -i ~/.ssh/brian_rsa brian@bcmilco.homelinux.org -p 2222'

alias make='make -j4'
alias sloccount='sloccount --effort 1 1 --schedule 1 1'
#alias top='htop'

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

