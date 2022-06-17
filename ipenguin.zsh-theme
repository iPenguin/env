local host='%{$fg[green]%}%m %{$reset_color%}'
local pwd='%{$fg_bold[blue]%}%~%{$reset_color%}'

local cmd_number='%{$fg_not_bold[]%}%h%{$reset_color%}'

local return_code='%(?:%{$fg_bold[green]%}✔:%{$fg_bold[red]%}✘%s%{$reset_color%}%?)'

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

precmd () {
    RPROMPT="$(parse_git_output) %{$fg[red]%}⟅%{$reset_color%}%!%{$fg[red]%}⟆%{$reset_color%}"
}

PROMPT="
%{$fg[red]%}#--[${return_code} ${host} ${pwd} %{$fg[red]%}]%# --≻ %{$reset_color%}
"

RPROMPT="$(parse_git_output)"
