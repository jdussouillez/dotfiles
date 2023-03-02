# ...

######################################
#               CUSTOM               #
######################################

########
# Misc #
########
export EDITOR="emacs"

alias l="ls"
alias la="ls -a"
alias ll="ls -lh"
alias lla="ls -lha"
alias alert='notify-send --urgency=low -i "$([ $? -eq 0 ] && echo terminal || echo error)"'
alias giveme="sudo chown junior:junior"
alias json="bat -l json"
alias yaml="bat -l yaml"

#######
# Git #
#######
alias gb="git branch -a"
alias gs="git status"

########
# LDAP #
########
alias ldapsearch='ldapsearch -x -W -H "ldap://<srv0>:389 ldap://<srv1>:389" -D "CN=DUSSOUILLEZ Junior,OU=<ou>,DC=<root>" -b "DC=<root>" -LLL'
alias ldapmodify='ldapmodify -x -W -H "ldap://<srv0>:389 ldap://<srv1>:389" -D "CN=DUSSOUILLEZ Junior,OU=<ou>,DC=<root>"'

########
# Java #
########
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

alias m="mvn"
alias mvn-update="m versions:display-dependency-updates"

mvn-version() {
    m versions:set -DnewVersion=$1 -DgenerateBackupPoms=false
}

###########
# Quarkus #
###########
alias qd="m quarkus:dev -Djvm.args=\"-Xmx512m\""

########
# gRPC #
########
alias grpcurl="/home/junior/Documents/Apps/grpcurl_1.8.7_linux_x86_64/grpcurl"

########
# Fuck #
########
eval $(thefuck --alias)

##########
# Backup #
##########
backup() {
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

unbackup() {
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

alias ubackup="unbackup"
alias ubak="unbackup"

#########
# Marks #
#########
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
jump() {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
alias j="jump"

mark() {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

unmark() {
    rm -i "$MARKPATH/$1"
}
alias umark="unmark"

marks() {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(find $MARKPATH -type l -printf "%f\n")
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

complete -F _completemarks jump j unmark umark

########
# Node #
########
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

###########
# Network #
###########
# SSH aliases
SERVERS=(
    srv0 # Server SRV0
    srv1 # Server SRV1
)
for server in "${SERVERS[@]}"; do
    alias $server="ssh ${server}.mydomain"
done

# Traceroute-mapper (https://github.com/stefansundin/traceroute-mapper)
traceroute-mapper() {
    xdg-open "https://stefansundin.github.io/traceroute-mapper/?trace=$(traceroute -q1 $* | sed ':a;N;$!ba;s/\n/%0A/g')"
}

##############
# Kubernetes #
##############
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
alias k="kubectl"
# alias connect-eks-test="aws-azure-login -m cli --no-prompt; eks-update-kubeconfig test-euw3"
# alias connect-eks-prod="aws-azure-login -m cli --no-prompt; eks-update-kubeconfig prod-euw3"
alias kgp="k get pod"
alias klog="k logs -f"
#alias krollout="k rollout restart"

kbash() {
    if [ "$#" -eq 1 ]; then
        k exec -it "$1" -- /bin/bash
    else
        k run alpine-debug --rm -i --tty --image alpine -- /bin/sh
    fi
}

source <(kubectl completion bash)
complete -F __start_kubectl k

#######
# AWS #
#######
alias ec2-connect="aws ssm start-session --target"
alias ec2-terminate="aws ec2 terminate-instances --instance-ids"
alias aws-local="aws --endpoint-url=http://127.0.0.1:4566"

###########
# Angular #
###########
source <(ng completion script)
