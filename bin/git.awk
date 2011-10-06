#!/usr/bin/awk -f
#
# (c) 2011 Brian C. Milco
#
# This script parses the output of several git commands and presents the
# information in one line that can be added to a command prompt (PS1).
#
# Sample output:
#
# ⑆ master ⑆ ⬆ 1 ⑆ ⬇ 1 ⑆ (1/2/3/4) ⑆ {1}
#
# What the output means:
#
# ⑆ - field seperator
# master - the branch name or (no branch) or (bare repository)
# ⬆ 1 - how many commits on this branch not in the remote branch. You need to push changes to remote.
# ⬇ 1 - how many commits on the remote branch not in this branch. You need to pull changes from remote.
# (1/2/3/4) - The count of changes in the repository:
# 1 - the number of staged changes. (green)
# 2 - the number of unstaged changes. (yellow)
# 3 - the number of unmerged changes. (magenta)
# 4 - the number of untracked changes. (red)
# {1} - the number of stashed changes. (yellow brackets)
#

function cmd( c )
{
    while( (c|getline foo) > 0 )
            continue;
    close( c );
    return foo;
}

BEGIN {

    isRepo = 0;

    output = cmd("git rev-parse --git-dir 2> /dev/null");

    if(output) {

        bareTest = cmd("cat " output "/config | grep \"bare\" 2> /dev/null");
        if(bareTest ~ "true")
            bareRepo = 1;
        
        stashCount = cmd("git stash list | wc -l 2> /dev/null"); 
        gsub(/ /,"",stashCount);
        
        isRepo = 1;
    }
}
{
    #only process lines that have data.
    if(skip > 0) {
        skip--;
        next;
    }

    test=$1 " " $2 " " $3;

    if(test == "# On branch") {
        branch = $4;
        next;
    } else if(test == "# Changes to") { #staged
        skip = 1;
        staged = 1;
        tracked = 1;
        merged = 1;
        next;
    } else if(test == "# Changes not") { #unstaged
        skip = 3;
        staged = 0;
        tracked = 1;
        merged = 1;
        next;
    } else if(test == "# Untracked files:") {#untracked
        skip = 2;
        staged = 0;
        tracked = 0;
        merged = 1;
        next;
    } else if(test == "# Unmerged paths:") {#unmerged
        skip = 2;
        staged = 0;
        tracked = 1;
        merged = 0;
        next;
    } else if($1 != "#") {
        next;
    } else if(test == "# Initial commit") {
        next;
    } else if(test == "# Your branch") { #branch is ahead/behind

        if($5 == "ahead") {
            ahead = $9;
        } else if($5 == "behind") {
            behind = $8;
        }         
        next;
    } else if(test == "# and have") { #branches have diverged
        ahead = $4;
        behind = $6;
        next;
    } else if(test == "# Not currently") {#detached HEAD
        branch = "(no branch)";
    }

    #Don't count blank lines
    if($0 == "#")
        next;
    
    if(staged == 1)
        changes["staged"] += 1;
    else if(staged == 0 && tracked == 1 && merged == 1)
        changes["unstaged"] += 1;
    else if(tracked == 0)
        changes["untracked"] += 1;
    else if(merged == 0)
        changes["unmerged"] += 1;

}
END {
    #colors:
    black="\033[30m";
    dark_gray="\033[01;30m";
    red="\033[31m";
    bright_red="\033[1;31m";
    green="\033[32m";
    bright_green="\033[1;32m";
    yellow="\033[33m";
    bright_yellow="\033[1;33m";
    blue="\033[34m";
    bright_blue="\033[1;34m";
    violet="\033[35m";
    bright_violet="\033[1;35m";
    cyan="\033[036m";
    bright_cyan="\033[1;36m";
    white="\033[37m";
    light_gray="\033[00;37m";
    end_color="\033[0m";

    if(isRepo == 1) {

        branchOutput = bright_red "⑆ ";

        if(bareRepo == 1) {
            branchOutput = branchOutput bright_cyan "(bare repository)";
        } else {
            branchOutput = branchOutput bright_cyan branch;
        }

        printf branchOutput dark_gray " ⑆ " end_color;

        if(bareRepo != 1) {
            if(ahead > 0) {
                printf bright_yellow "⬆ " end_color ahead dark_gray " ⑆ " end_color;
            } 
            if (behind > 0) {
                printf bright_yellow "⬇ " end_color behind dark_gray " ⑆ " end_color;
            }

            #if there are changes show the output.
            if(changes["staged"] > 0 || changes["unstaged"] > 0 || changes["untracked"] > 0 || changes["unmerged"] > 0) {
                output = "(";

                if(changes["staged"] >= 1) {
                    output = output bright_green changes["staged"];
                } else {
                    output = output bright_green "-";
                }

                output = output end_color "/";

                if(changes["unstaged"] >= 1) {
                    output = output bright_yellow changes["unstaged"];
                } else {
                    output = output bright_yellow "-";
                }
                output = output end_color "/";

                if(changes["unmerged"] >= 1) {
                    output = output violet changes["unmerged"];
                } else {
                    output = output violet "-";
                }
                output = output end_color "/";

                if(changes["untracked"] >= 1) {
                    output = output bright_red changes["untracked"];
                } else {
                    output = output bright_red "-";
                }

                printf output end_color ") ";
            } else {
                printf "no local changes ";
            }  
            
            if(stashCount > 0) {
                printf dark_gray "⑆ " end_color bright_yellow "{" end_color stashCount bright_yellow "} " end_color;
            }
        } else {
            printf "no working branch ";
        }

        printf end_color;
    }       
}
