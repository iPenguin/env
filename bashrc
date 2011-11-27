#
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

alias lsd='ls -aFh --color --group-directories-first'
alias cp='cp -i'
alias df='df -h'
alias du='du -h'
alias mv='mv -i'
alias rm='rm -i'
alias less='less -R'
alias grep='grep --color'
alias git-netbook='git pull --tags netbook working'
alias git-desktop='git pull --all --tags'

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
alias sshhome='ssh bcmilco.homelinux.org -p 2222'

alias make='make -j4'
alias sloccount='sloccount --effort 1 .7 --schedule 1 1'
alias top='htop'

# ⚫ ❨ ❩ ⬆ ⬇ ⑈ ⑉ ǁ ║ ⑆ ⑇ ⟅ ⟆ ⬅ ➤ ➥ ➦ ➡
SEPARATOR="ǁ"
SEPARATOR2="⚫"

HISTSIZE=5000
PATH="~/bin:~/env.git/bin:$PATH"
EDITOR="/usr/bin/vim"

function parse_git_output {

    output=$(git status 2> /dev/null | git.awk -v separator=$SEPARATOR separator2=$SEPARATOR2 2> /dev/null) || return
    echo -e "$output";
}

BLACK="\[\e[00;30m\]"
DARY_GRAY="\[\e[01;30m\]"
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
ENDCOLOR="\e[m"


if [ "$SSH_CONNECTION" == "" ]; then
    PS1="${BRIGHT_RED}#--[ ${GREEN}\h ${DARY_GRAY}${SEPARATOR} ${BRIGHT_BLUE}\w \$(parse_git_output)${BRIGHT_RED}]\\$ --≻${ENDCOLOR}\n"
else
    PS1="${BRIGHT_RED}#--[ ${YELLOW}\h ${DARY_GRAY}${SEPARATOR} ${BRIGHT_BLUE}\w \$(parse_git_output)${BRIGHT_RED}]\\$ --≻${ENDCOLOR}\n"
fi

export PATH EDITOR HISTSIZE

