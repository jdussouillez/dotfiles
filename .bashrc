#
############### CUSTOM ###############
#

SERVERS=(
    srv0 # Server SRV0
)

for server in "${SERVERS[@]}"; do
    alias $server="ssh ${server}.mydomain"
done

alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias lla='ls -lha'
alias alert='notify-send --urgency=low -i "$([ $? -eq 0 ] && echo terminal || echo error)"'

alias gb='git branch -a'
alias gs='git status'

alias ldapsearch='ldapsearch -x -W -H "ldap://<srv1>:389 ldap://<srv1>" -D "CN=DUSSOUILLEZ Junior,OU=..." -b "DC=<root>" -LLL'
alias ldapmodify='ldapmodify -x -W -H "ldap://<srv1>:389 ldap://<srv2>" -D "CN=DUSSOUILLEZ Junior,OU=..."'

alias mvn-update='mvn versions:display-dependency-updates'
alias giveme="sudo chown <myuser>:<mygroup>"

mvn-version() {
    mvn versions:set -DnewVersion=$1 -DgenerateBackupPoms=false
}

# https://github.com/nvbn/thefuck
eval $(thefuck --alias)

########## BACKUP ##########
function backup {
    if [ $# -ne 1 ]; then
	echo "Usage: backup <FILE/FOLDER>"
	return 1
    fi
    local FILE="$1"
    local DATETIME=$(date "+%d-%m-%Y_%H-%M-%S")
    if [ -d "$FILE" ]; then
	FILE=${FILE%/} # Remove the last "/" (if there is one)
	tar -cvf "${FILE}_$DATETIME.tar.gz.bak" "$FILE"
	echo "'$FILE' -> '${FILE}_$DATETIME.tar.gz.bak'"
    else
	cp -avf "$FILE" "${FILE}_$DATETIME.bak"
    fi
    return $?
}
alias bak='backup'

function unbackup {
    if [ $# -ne 1 ]; then
	echo "Usage: unbackup <FILE.BAK>"
	return 1
    fi
    local BAK_FILE=$1
    local LAST_EXT=${BAK_FILE##*.}
    if [ "$LAST_EXT" != "bak" ]; then
	echo "Error: not a \".bak\" file"
	return 2
    fi
    local EXT=${BAK_FILE#*.}
    local FILE=${BAK_FILE%%.*}
    if [ "$EXT" = "tar.gz.bak" ]; then
	mkdir -vp "$FILE"
	tar -xvf "$BAK_FILE" -C "$FILE"
	echo "'$BAK_FILE' -> '$FILE'"
    else
	cp -v "$BAK_FILE" "$FILE"
    fi
    return $?
}

alias ubackup='unbackup'
alias ubak='unbackup'

########## MARKS ##########
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
#
export MARKPATH=$HOME/.marks
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
alias j="jump"

function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

function unmark {
    rm -i "$MARKPATH/$1"
}
alias umark="unmark"

function marks {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(find $MARKPATH -type l -printf "%f\n")
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

complete -F _completemarks jump j unmark umark

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Traceroute-mapper
# https://github.com/stefansundin/traceroute-mapper
function traceroute-mapper {
    xdg-open "https://stefansundin.github.io/traceroute-mapper/?trace=$(traceroute -q1 $* | sed ':a;N;$!ba;s/\n/%0A/g')"
}
