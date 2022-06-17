#!/usr/bin/awk -f
#
# (c) 2011-2014 Brian C. Milco <bcmilco AT gmail DOT com>
#
# This script parses the output of several git commands and presents the
# information in one line that can be added to a command prompt (PS1).
#
# Use -v separator="|" separator2="/" to use other field separators.
#

function cmd( c )
{
    while( (c|getline foo) > 0 )
        continue;
    close( c );
    return foo;
}

BEGIN {
    dark_gray="\033[01;30m";
    bright_red="\033[1;31m";
    bright_green="\033[1;32m";
    bright_yellow="\033[1;33m";
    blue="\033[34m";
    bright_blue="\033[1;34m";
    violet="\033[35m";
    bright_cyan="\033[1;36m";
    endc="\033[0m";

    separator = dark_gray (separator == "" ? "|" : separator) endc;
    separator2 = dark_gray (separator2 == "" ? "/" : separator2) endc;

    #test if this is a git repo.
    repo = cmd("git rev-parse --git-dir 2> /dev/null");

    if(repo) {
        bareRepo = cmd("cat " repo "/config | grep \"bare\" 2> /dev/null");
        stashCount = cmd("git stash list | wc -l 2> /dev/null");
    }

    changes["staged"] = 0;
    changes["unstaged"] = 0;
    changes["untracked"] = 0;
    changes["unmerged"] = 0;
}
{
    if($0 ~ "##") {
        match_location = match($0, /No commits/);
        
        if( match_location > 0 ) {
            branch = "(no branch)"
            next;
        }

        match($2, /(.+)\.\.\.(.+)/, array); #branch w/remote

        branch = (array[1] == "" ? $2 : array[1]);

        if( $0 ~ "\\[" ) {
            split($0, ab, "\[");
            sub("\]", "", ab[2]);

            split(ab[2], ab, " ");
            idx = 1;
            if( ab[idx] ~ "ahead" ) {
                ahead = ab[idx + 1];
                sub(",", "", ahead);
                idx += 2;
            }

            if( ab[idx] ~ "behind" ) {
                behind = ab[idx + 1];
            }
        }
    } else {

        xy = substr($0, 0, 2);
        split(xy, status, //);

        if($0 ~ "\?+") {
            changes["untracked"]++;
        }

        if(status[1] ~ "[MADRC]") {
            changes["staged"]++;
        }

        if(status[2] ~ "[MD]") {
            changes["unstaged"]++;
        }

        if(status[1] ~ "[DAU]" && status[2] ~ "[DAU]") {
           changes["unmerged"]++;
        }

    }
}
END {

    output = separator " " bright_cyan;
    if(repo) {

        if(bareRepo ~ "true") {
            output = output "(bare repository) ";
        } else {
            output = output branch " ";

            if(ahead > 0) {
                output = output bright_yellow "⬆" endc ahead " ";
            }
            if (behind > 0) {
                output = output bright_yellow "⬇" endc behind " ";
            }

            #if there are any changes show them.
            if(changes["staged"] > 0 || changes["unstaged"] > 0 \
               || changes["untracked"] > 0 || changes["unmerged"] > 0) {

                output = output bright_green changes["staged"] endc separator2;
                output = output bright_yellow changes["unstaged"] endc separator2;
                output = output violet changes["unmerged"] endc separator2;
                output = output bright_red changes["untracked"] endc " ";

            }

            if(stashCount > 0) {
                output = output separator bright_yellow stashCount endc;
            }
        }

        printf output endc;
    }
}
