#!/usr/bin/awk -f
#
# (c) 2011 Brian C. Milco
#
# This script parses the output of git status and figures out
# which top level folders in the repository have modified files.
#
# Sample output for a git repo at ~/env.git:
#
# #--[ env.git ⑆ master ⑆ no local changes ]--≻
#
# #--[ env.git ⑆ master ⑆ ⬆ 5 ⑆ ⬇ 2 ⑆ bin(-/1/1) ]--≻
#
# What the output means:
# The line starts with a hash making the output a comment.
# the information that can be inside the braces is as follows:
# the repository (folder) name
# the branch name - or (no branch) or (bare repository)
# If there are changes the following maybe displayed as needed:
# ⬆ [number] - how many commits on this branch not in the remote branch. You need to push changes to remote.
# ⬇ [number] - how many commits on the remote branch not in this branch. You need to pull changes from remote.
# [folderName](1/2/3) - a list of directories that contain changes. The change count is listed in parentheses and mean the following:
# the first number is the number of staged changes. (green)
# the second number is the number of unstaged changes. (yellow)
# the third number is the number of untracked changes. (red)
# 

function cmd( c )
{
    while( (c|getline foo) > 0 )
            continue;
    close( c );
    return foo;
}

BEGIN {
    curPath = cmd("pwd");

    pwdCount = split(curPath, pwd, "/");
    repoPath = "";
    repo = "";
    isRepo = 0;
    for(i = 2; i <= pwdCount; i++) {
        repoPath = repoPath "/" pwd[i];
        output = cmd("/bin/ls -d " repoPath "/.git 2> /dev/null");

        
        if(output == repoPath"/.git")
            repoPath = repoPath"/.git";

        if(match(repoPath, "\\.git")) {
            bareTest = cmd("cat " repoPath "/config | grep \"bare\" 2> /dev/null");
            if(bareTest ~ "true")
                bareRepo = 1;

            isRepo = 1;
            repo = pwd[i];
            break;
        }
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
    } else if(test == "# Changes to") {
        skip = 2;
        staged = 1;
        tracked = 1;
        next;
    } else if(test == "# Changes not") {
        skip = 3;
        staged = 0;
        tracked = 1;
        next;
    } else if(test == "# Untracked files:") {
        skip = 2;
        staged = 0;
        tracked = 0;
        next;
    } else if(test == "no changes added") {
        next;
    } else if(test == "nothing to commit") {
        next;
    } else if(test == "# Your branch") {

        if($5 == "ahead") {
            ahead = $9;
        } else if($5 == "behind") {
            behind = $8;
        }         
        next;
    } else if(test == "# and have") { #diverged line 2
        ahead = $4;
        behind = $6;
        next;
    } else if(test == "# Not currently") {
        branch = "(no branch)";
    }

    fileName ="";
    if($2 ~ ".*modified:") {
        $1 = "";
        $2 = "";
        fileName = substr($0, 3);
    } else if($2 " " $3 ~ ".*new file:") {
        $1 = "";
        $2 = "";
        $3 = "";
        fileName = substr($0, 4);
    } else if($2 ~ ".*deleted:") {
        $1 = "";
        $2 = "";
        fileName = substr($0, 3);
    } else if($2 ~ ".*renamed:") {
        $1 = "";
        $2 = "";
        idx = index($0, "->");
        fileName = substr($0, 3, idx);
    } else {
        $1 = "";
        if($0 == "")
            next;
        fileName = substr($0, 2);
    }

    count = split(fileName,path,"/");

    folder = "";

    if(count == 1) {
        folder = ".";
    } else if(count > 1) {
        for(i = 1; i <= count; i++) {
            if(path[i] == ".." && (count - i) > 1)
                continue;
            else {
                if(path[i] == "..")
                    folder = ".";
                else
                    folder = path[i];
                break;
            }
        }
    }

    folders[folder] = 1;

    if(staged == 1)
        changes[folder,"staged"] += 1;
    else if(staged == 0 && tracked == 1)
        changes[folder,"unstaged"] += 1;
    else if(staged == 0 && tracked == 0)
        changes[folder,"untracked"] += 1;

}
END {
    #colors:
    end_color="\033[0m";
    black="\033[30m";
    light_gray="\033[00;37m";
    dark_gray="\033[01;30m";
    red="\033[31m";
    bright_red="\033[1;31m";
    green="\033[32m";
    bright_green="\033[1;32m";
    yellow="\033[33m";
    bright_yellow="\033[1;33m";
    violet="\033[35m";
    bright_violet="\033[1;35m";
    cyan="\033[036m";
    bright_cyan="\033[1;36m";
    blue="\033[34m";
    bright_blue="\033[1;34m";
    white="\033[37m";

    if(isRepo == 1) {

        printf bright_red "#--[ " bright_blue repo end_color;

        branchOutput = dark_gray " ⑆ ";

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

            output = "";
            for(item in folders) {
                output = output item "(";
                if(changes[item,"staged"] >= 1) {
                    output = output bright_green changes[item,"staged"] end_color;
                } else {
                    output = output bright_green "-" end_color;
                }
                output = output "/";

                if(changes[item,"unstaged"] >= 1) {
                    output = output bright_yellow changes[item,"unstaged"] end_color;
                } else {
                    output = output bright_yellow "-" end_color;
                }
                output = output "/";

                if(changes[item,"untracked"] >= 1) {
                    output = output bright_red changes[item,"untracked"] end_color;
                } else {
                    output = output bright_red "-" end_color;
                }
                output = output ") ";
            }

            if(output != "")
                printf output;
            else
                printf "no local changes ";
        } else {
            printf "no working branch ";
        }

        printf bright_red "]--≻" end_color;
    }       
}
