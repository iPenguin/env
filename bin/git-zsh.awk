#!/usr/bin/awk -f
#
# (c) 2011-2014 Brian C. Milco <bcmilco AT gmail DOT com>
#
# This script distills git status info for use in a shell prompt (PS1).
# Use -v separator="|" separator2="/" to use other field separators.
#

function cmd( c )
{
    while( (c|getline data) > 0 )
        continue;
    close( c );
    return data;
}

BEGIN {
    endc="%{\033[0m%}";

    separator = "%{\033[01;30m%}" (separator == "" ? "|" : separator) endc;
    separator2 = "%{\033[01;30m%}" (separator2 == "" ? "/" : separator2) endc;

    repo = cmd("git rev-parse --git-dir 2> /dev/null");
    if(repo) {
        bareRepo = cmd("cat " repo "/config | grep \"bare\" 2> /dev/null");
        stashCount = cmd("git stash list | wc -l 2> /dev/null");
    }
}
{
    if($0 ~ "##") {
        #match requires gawk
        match($2, /(.+)\.\.\.(.+)/, array); #branch w/remote
        branch = (array[1] == "" ? $2 : array[1]);

        if( $0 ~ "ahead" ) {
            ahead=1;
        }
        if( $0 ~ "behind" ) {
            behind=1;
        }
        next;
    }

    if($0 != "") {
        changes=1;
        nextfile;
    }
}
END {
    if( repo ) {
        output = separator " %{\033[1;36m%}"
        if(bareRepo ~ "true") {
            output = output "(bare repo) ";
        } else {
            output = output branch "%{\033[01;33m%}"; #yellow

            if( ahead && behind ) {
                output = output "⬍";
            } else if( ahead ) {
                output = output "⬆";
            } else if( behind ) {
                output = output "⬇";
            }

            if( changes ) {
                output = output "Δ ";
            }

            if( stashCount ) {
                output = output "⥃ ";
            }
        }
        printf output endc;
    }
}
