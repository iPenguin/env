local host='%{$fg[green]%}%m %{$reset_color%}'
local pwd='%{$fg_bold[blue]%}%~%{$reset_color%}'

local cmd_number='%{$fg_not_bold[]%}%h%{$reset_color%}'

local return_code='%(?:%{$fg_bold[green]%}✔:%{$fg_bold[red]%}✘%s%{$reset_color%}%?)'
local git_branch='$(git_prompt_info) %{$reset_color%}$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}±%{$reset_color%} %{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} Δ%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}∗ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✘ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭ "

function parse_git_output () {
    p=$(pwd)
    # Don't do git status over networked paths.
    # It kills performance, and the prompt takes forever to return.
    if [[ $p =~ "/net/" ]]; then
        return
    fi

    output=$(git status -sb --porcelain 2> /dev/null | git-details-zsh.awk 2> /dev/null)
    echo "$output"
}
BATTERY_GAUGE_PREFIX='⟪'
BATTERY_GAUGE_SUFFIX='⟫'
BATTERY_GAUGE_FILLED_SYMBOL='▪'
BATTERY_GAUGE_EMPTY_SYMBOL='▫'

precmd () {
    RPROMPT="$(parse_git_output) $(battery_level_gauge)"
}

PROMPT="
%{$fg[red]%}#--[${return_code} ${host} ${pwd} %{$fg[red]%}]%# --≻ %{$reset_color%}
"

RPROMPT="$(parse_git_output)"
