# -*- sh -*- # Tells Emacs to use Bash syntax highlighting

# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
        # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
        if type -P dircolors >/dev/null ; then
                if [[ -f ~/.dir_colors ]] ; then
                        eval $(dircolors -b ~/.dir_colors)
                elif [[ -f /etc/DIR_COLORS ]] ; then
                        eval $(dircolors -b /etc/DIR_COLORS)
                fi
        fi

        if [[ ${EUID} == 0 ]] ; then
                PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
        else
                PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
        fi

        alias ls='ls --color=auto'
        alias grep='grep --colour=auto'
else
        if [[ ${EUID} == 0 ]] ; then
                # show root@ when we don't have colors
                PS1='\u@\h \W \$ '
        else
                PS1='\u@\h \w \$ '
        fi
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- $1
                   return $?
		else
		   return 127
		fi
	}
fi

#/usr/bin/mint-fortune



#
########################
#        CUSTOM        #
########################
#


#
#
########## MARKS ##########
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
#
export MARKPATH=$HOME/.marks
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
    rm -i "$MARKPATH/$1"
}
function marks {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark


#
########## BACKUP ##########
#
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

#
########## ALERT ##########
#
# Notify when a command is finished
# sleep 5; alert "finished !"
alias alert='notify-send --urgency=low -i "$([ $? -eq 0 ] && echo terminal || echo error)"'


#
########## LIBS ##########
#
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/x86_64-linux-gnu/


#
########## ALIASES ##########
#
# Clean/Clean recursive and simulate clean
alias sclean='find . -maxdepth 1 -name "*~" -o -name ".*~" -type f | xargs echo'
alias scleanr='find . -name "*~" -o -name ".*~" -type f | xargs echo'
alias clean='find . -maxdepth 1 -name "*~" -o -name ".*~" -type f | xargs rm -vf'
alias cleanr='find . -name "*~" -o -name ".*~" -type f | xargs rm -vf'

# To ignore "Gtk-WARNING" messages
alias emacs='emacs 2>/dev/null'
alias pluma='pluma 2>/dev/null'
alias gparted='gparted 2>/dev/null'
alias nemo='nemo 2>/dev/null'
alias atril='atril 2>/dev/null'

# Git
alias gl='git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
alias git-tree='perl ~/Documents/Progs/forest.pl --pretty=format:"%C(red)%h %C(magenta)(%ar) %C(blue)%an %C(reset)%s" --style=15'
alias gt='git-tree'
alias gu='git up'
alias gs='git status'
alias gd='git diff'
alias gb='git branch -a'

# Others
alias ll='ls -lh'
alias la='ls -a'
alias e='emacs -nw 2>/dev/null'
alias pdf='atril'
alias gcc='colorgcc'
alias rsvn='export LANG=C; rapidsvn &'
