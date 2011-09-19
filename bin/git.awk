#!/usr/bin/awk -f
#
# (c) 2011 Stitch Works Software
# Brian C. Milco <brian@stitchworkssoftware.com>
#
# This script parses the output of git status and figures out
# which base folders in the repo have modified files.
#
# Sample output for a git repo at ~/program.git:
#
# program.git: . src docs tests src src
#
# the output is colorized and src is in the list 3 times because
# it's contains staged changes, unstaged changes, and untracked changes.
#

function cmd( c )
{
    while( (c|getline foo) > 0 )
            continue;
    close( c );
    return foo;
}

BEGIN {
    skip = 0;
    ahead = 0;
    staged = 1;
    tracked = 1;

    curPath = cmd("pwd");

    pwdCount = split(curPath, pwd, "/");
    repoPath = "";
    repo = "";
    isRepo = 0;
    for(i = 2; i <= pwdCount; i++) {
        repoPath = repoPath "/" pwd[i];
        output = cmd("/bin/ls -d " repoPath "/.git 2> /dev/null");

        if(output == repoPath"/.git") {
            bareTest = cmd("cat " repoPath "/.git/config | grep \"bare\" 2> /dev/null");
            if(bareTest ~ "true")
                bareRepo = 1;

            isRepo = 1;
            repo = pwd[i];
            break;
        }
    }
}
{
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
        ahead = 1;
        next;
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
        changes[folder,"staged"] = 1;
    else if(staged == 0 && tracked == 1)
        changes[folder,"unstaged"] = 1;
    else if(staged == 0 && tracked == 0)
        changes[folder,"untracked"] = 1;

}
END {
    #colors:
    
    end_color="\033[0m";
    black="\033[30m";
    red="\033[31m";
    bright_red="\033[1;31m";
    green="\033[32m";
    bright_green="\033[1;32m";
    yellow="\033[33m";
    bright_yellow="\033[1;33m";
    violet="\033[35m";
    bright_violet="\033[1;35m";
    cyan="\033[036m";
    light_cyan="\033[1;36m";
    blue="\033[34m";
    light_blue="\033[1;34m";
    white="\033[37m";

    if(isRepo == 1) {
        if(bareRepo == 1) {
            branch = light_cyan " ⑆" cyan " bare repo " light_cyan "⑆";
        } else {
            branch = light_cyan " ⑆ " end_color cyan branch " " end_color;
        }

        printf blue repo branch;

        if(bareRepo != 1) {
            if(ahead == 1) {
                printf bright_yellow "⬆ " end_color;
            }

            printf light_cyan "⑆ " end_color;

            output = "";
            for(item in folders) {
                output = output item;
                if(changes[item,"staged"] == 1)
                    output = output bright_green "*" end_color;
                if(changes[item,"unstaged"] == 1)
                    output = output bright_yellow "*" end_color;
                if(changes[item,"untracked"] == 1)
                    output = output bright_red "*" end_color;
                output = output " ";
            }

            if(output != "")
                printf output;
            else
                printf end_color "no local changes";
        }
    }       
}
