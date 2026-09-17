#!/bin/bash

#######################################################
# SOURCED ALIASES AND SCRIPTS
#######################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
	 . /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

#######################################################
# EXPORTS
#######################################################

# Disable the bell
[[ $- == *i* ]] && bind "set bell-style visible"

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it
shopt -s histappend

# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon

# Ignore case on auto-completion
[[ $- == *i* ]] && bind "set completion-ignore-case on"

# Show auto-completion list automatically, without double tab
[[ $- == *i* ]] && bind "set show-all-if-ambiguous On"

# Set the default editor
export EDITOR=vim
export VISUAL=vim
alias pico='edit'
alias spico='sedit'
alias nano='edit'
alias snano='sedit'

# Colors for manpages in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Aliases to change the directory
alias web='cd /var/www/html'

#######################################################
# GENERAL ALIASES
#######################################################

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'

# Show help for this .bashrc file
alias hlp='less ~/.bashrc_help'

# Alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Aliases to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias vi='vim'
alias svi='sudo vi'
alias vis='vim "+set si"'

# Prefer trash-put (recoverable deletes) when available
if command -v trash-put &> /dev/null; then
	alias rm='trash-put'
else
	alias rm='rm -iv'
fi

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search running processes
alias p="ps aux | grep "

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Show current network connections to the server
alias ipview='ip -o addr show scope global | awk "{print \$2, \$4}" | column -t'

# Show open ports
alias openports='netstat -nape --inet'

# Aliases for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Aliases to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r | less -R"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias mountedinfo='df -hT' # Consider swapping to 'duf' in the future

# Aliases for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Logs and Process
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias psme="ps aux | awk -v user=\"\$(whoami)\" 'BEGIN {printf \"%-15s %-10s %-7s %-7s %-10s %s\n\", \"USER\", \"PID\", \"%CPU\", \"%MEM\", \"VSZ\", \"COMMAND\"} \$1 == user {printf \"%-15s %-10s %-7s %-7s %-10s %s\n\", \$1, \$2, \$3, \$4, \$5, substr(\$0, index(\$0,\$11))}'"

# SHA1
alias sha1='openssl sha1'

# Fast Copy with progress bar using rsync
alias cpp='rsync -ah --info=progress2'

#######################################################
# MODERN CLI TOOLS (eza, fd, rg, zoxide)
#######################################################

# eza (Modern ls replacement)
alias ls='eza --color=always --group-directories-first'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --level=2'

# ripgrep (Modern grep/ftext replacement)
alias grep='rg'
alias ftext='rg'
alias h="history | rg "

# fd-find (Modern find replacement)
# Ubuntu installs this as fdfind
alias f='fdfind'
alias fd='fdfind'

# zoxide (Modern cd / up replacement)
eval "$(zoxide init bash)"
alias cd='z'

#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Safely extract any archive
extract () {
	for archive in "$@"; do
		if [ -f "$archive" ] ; then
			case "$archive" in
				*.tar.bz2)   tar xvjf "$archive"    ;;
				*.tar.gz)    tar xvzf "$archive"    ;;
				*.bz2)       bunzip2 "$archive"     ;;
                *.rar)       unrar x "$archive"     ;;
				*.gz)        gunzip "$archive"      ;;
				*.tar)       tar xvf "$archive"     ;;
				*.tbz2)      tar xvjf "$archive"    ;;
				*.tgz)       tar xvzf "$archive"    ;;
				*.zip)       unzip "$archive"       ;;
				*.Z)         uncompress "$archive"  ;;
				*.7z)        7z x "$archive"        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Returns the last 2 fields of the working directory
pwdtail ()
{
	pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Modernized OS and Version checks
distribution () {
    grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"'
}

# Show the current version of the operating system
ver () {
    grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"'
}

# Modernized Network Info
netinfo() {
    ip -br addr show | awk '{print $1, $2, $3}'
}

# Edit the MySQL configuration file
mysqlconfig ()
{
	if [ -f /etc/my.cnf ]; then
		sedit /etc/my.cnf
	elif [ -f /etc/mysql/my.cnf ]; then
		sedit /etc/mysql/my.cnf
	elif [ -f /usr/local/etc/my.cnf ]; then
		sedit /usr/local/etc/my.cnf
	elif [ -f /usr/bin/mysql/my.cnf ]; then
		sedit /usr/bin/mysql/my.cnf
	elif [ -f ~/my.cnf ]; then
		sedit ~/my.cnf
	elif [ -f ~/.my.cnf ]; then
		sedit ~/.my.cnf
	else
		echo "Error: my.cnf file could not be found."
		echo "Searching for possible locations:"
		sudo updatedb && locate my.cnf
	fi
}

rot13 () {
	if [ $# -eq 0 ]; then
		tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
	else
		echo "$*" | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
	fi
}

# Trim leading and trailing spaces (for scripts)
trim()
{
	local var="$*"
	var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
	var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters
	echo -n "$var"
}

_docker_cli_wipe() {
    echo "Clearing buildx builders and cache ...";
    docker buildx ls --format "{{ .Name }}" 2>/dev/null | xargs -r -I{} docker buildx stop {} > /dev/null 2>&1
    docker buildx ls --format "{{ .Name }}" 2>/dev/null | xargs -r -I{} docker buildx rm --force {} > /dev/null 2>&1
    docker buildx prune --all --force > /dev/null 2>&1
    echo "Stopping and removing all containers ...";
    docker container ls --all --quiet | xargs -r docker container stop > /dev/null 2>&1
    docker container ls --all --quiet | xargs -r docker container rm --force > /dev/null 2>&1
    echo "Doing a full docker system prune ...";
    docker system prune --all --force --volumes
}

_docker_wipe_warn() {
    echo "This will remove ALL Docker containers, images, volumes, and build cache on this machine:"
    docker container ls --all --format '  - %s (%s)' 2>/dev/null
    echo "Ctrl-C in the next 4s to cancel ..."
    sleep 4
}

docker-prune ()
{
    local deep=false
    [[ "$1" == "--deep" ]] && deep=true

    _docker_wipe_warn

    if $deep; then
        echo "DEEP CLEAN: stopping Docker and wiping /var/lib/docker + /var/lib/containerd directly."
        sudo systemctl stop docker
        sudo rm -rf /var/lib/docker/*
        sudo rm -rf /var/lib/containerd/*
        sudo systemctl start docker
        sleep 2
    fi

    _docker_cli_wipe

    echo "*** Containers remaining:"
    docker container ls
    echo "*** Images remaining:"
    docker image ls
}

fn_submodule_update()
{
  echo "Updated all submodules"
  git submodule update --init --recursive --rebase --force
}

diskhealth() {
    echo -e "\e[1;34m========================================================\e[0m"
    echo -e "\e[1;34m                DISK & DOCKER USAGE DASHBOARD           \e[0m"
    echo -e "\e[1;34m========================================================\e[0m"

    echo -e "\n\e[1;33m[1] PHYSICAL DISK SPACE\e[0m"
    df -h -x tmpfs -x squashfs -x devtmpfs -x efivarfs

    echo -e "\n\e[1;33m[2] DOCKER STORAGE BREAKDOWN\e[0m"
    if command -v docker &> /dev/null && docker info &> /dev/null; then
        echo -e "Docker Storage Root: \e[1;31m$(docker info 2>/dev/null | grep 'Docker Root Dir' | awk '{print $NF}')\e[0m"
        echo ""
        docker system df
    else
        echo "Docker daemon is not running or lacks permissions."
    fi

    echo -e "\n\e[1;33m[3] SYSTEM CACHES & LOGS\e[0m"
    # Systemd Journal Logs
    if command -v journalctl &> /dev/null; then
        JOURNAL_SIZE=$(journalctl --disk-usage 2>/dev/null | grep -oE '[0-9.]+[KMGTP]B?' | tail -n 1)
        echo "  • Journal Logs: ${JOURNAL_SIZE:-Unknown}"
    fi
    # APT Cache (Debian/Ubuntu)
    if [ -d /var/cache/apt/archives ]; then
        echo "  • APT Package Cache: $(du -sh /var/cache/apt/archives 2>/dev/null | cut -f1)"
    fi
    # /var/log Size (no sudo) - only compute when the directory exists
    if [ -d /var/log ]; then
        projected_log_size=$(du -sh /var/log 2>/dev/null | cut -f1)
        echo "  • Total /var/log Usage: $projected_log_size"
    fi

    echo -e "\n\e[1;34m========================================================\e[0m"
}

fn_xclean() {
    local clean_docker=false
    [[ "$1" == "--docker" ]] && clean_docker=true

    toplevel="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -z "$toplevel" ]]; then
        echo "Not inside a git repo - aborting."
        return 1
    fi

    echo "$(date +%H:%M:%S) *** ================================================================================"
    echo "$(date +%H:%M:%S) *** Cleaning up Python virtual environments."
    echo "$(date +%H:%M:%S) *** ----------------------------------------"
    if [[ -d "${toplevel}" ]] ; then
        (
            cd "${toplevel}"
            none=true
            for dspec in $(find . -type d -name .venv) ; do
                echo "$(date +%H:%M:%S)     - ${dspec}"
                rm -rf "${dspec}"
                none=false
            done
            ${none} && echo "$(date +%H:%M:%S)     There were none."
        )
    fi
    echo

    echo "$(date +%H:%M:%S) *** ================================================================================"
    echo "$(date +%H:%M:%S) *** Cleaning up Python caches."
    echo "$(date +%H:%M:%S) *** --------------------------"
    if [[ -d "${toplevel}" ]] ; then
        (
            none=true
            cd "${toplevel}"
            for dspec in $(find . -type d -name __pycache__) ; do
                echo "$(date +%H:%M:%S)     - ${dspec}"
                rm -rf "${dspec}"
                none=false
            done
            ${none} && echo "$(date +%H:%M:%S)     There were none."
        )
    fi
    echo

    echo "$(date +%H:%M:%S) *** ================================================================================"
    echo "$(date +%H:%M:%S) *** Cleaning up work areas."
    echo "$(date +%H:%M:%S) *** -----------------------"
    if [[ -d "${toplevel}" ]] ; then
        (
            cd "${toplevel}"
            for dspec in */work work ; do
                echo "$(date +%H:%M:%S)     - ${dspec}"
                rm -rf "${dspec}"
            done
        )
    fi
    echo

    if $clean_docker; then
        echo "$(date +%H:%M:%S) *** ================================================================================"
        echo "$(date +%H:%M:%S) *** Docker cleanup (--docker passed - this is machine-wide, not repo-scoped)."
        echo "$(date +%H:%M:%S) *** -------------------------------------------------------------------------"
        _docker_wipe_warn
        sudo systemctl stop docker
        _docker_cli_wipe
        sudo systemctl start docker
        echo "*** Containers remaining:"
        docker container ls
        echo "*** Images remaining:"
        docker image ls
        echo
    fi

    echo "$(date +%H:%M:%S) *** ================================================================================"
    echo "$(date +%H:%M:%S) *** Finished."
    echo "$(date +%H:%M:%S) *** ---------"
}

alias xclean='fn_xclean'

#######################################################
# Set the ultimate amazing command prompt
#######################################################

alias cpu="grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage}' | awk '{printf(\"%.1f\n\", \$1)}'"
function __setprompt
{
    local LAST_COMMAND=$?

    local LIGHTGRAY="\033[0;37m"
    local WHITE="\033[1;37m"
    local DARKGRAY="\033[1;30m"
    local RED="\033[0;31m"
    local LIGHTRED="\033[1;31m"
    local GREEN="\033[0;32m"
    local BROWN="\033[0;33m"
    local BLUE="\033[0;34m"
    local MAGENTA="\033[0;35m"
    local CYAN="\033[0;36m"
    local NOCOLOR="\033[0m"

    if [[ $LAST_COMMAND != 0 ]]; then
        PS1="\[${DARKGRAY}\](\[${LIGHTRED}\]ERROR\[${DARKGRAY}\])-(\[${RED}\]Exit \[${LIGHTRED}\]${LAST_COMMAND}\[${DARKGRAY}\])\n"
    else
        PS1=""
    fi

    # Native Bash Time/Date (Zero latency)
    PS1+="\[${DARKGRAY}\](\[${CYAN}\]\d\[${BLUE}\] \@\[${DARKGRAY}\])-"

    # Jobs
    PS1+="(\[${MAGENTA}\]Jobs:\j\[${DARKGRAY}\])-"

    # User and server
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH2_CLIENT" ] ; then
        PS1+="(\[${RED}\]\u@\h"
    else
        PS1+="(\[${RED}\]\u"
    fi

    # Current directory
    PS1+="\[${DARKGRAY}\]:\[${BROWN}\]\w\[${DARKGRAY}\])\n"

    # User prompt
    if [[ $EUID -ne 0 ]]; then
        PS1+="\[${GREEN}\]>\[${NOCOLOR}\] "
    else
        PS1+="\[${RED}\]>\[${NOCOLOR}\] "
    fi

    PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "
    PS3='Please enter a number from above list: '
    PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}

# Runs before every prompt: sync history immediately, then build the prompt.
PROMPT_COMMAND='history -a; __setprompt'
umask 022

# Persist the ssh-agent's environment to a file and source it on shell
# start, so every new shell reuses the same agent instead of starting a
# fresh one that only the current shell knows about.
SSH_ENV="$HOME/.ssh/agent-environment"

fn_start_ssh_agent() {
    echo "Starting new ssh-agent..."
    ssh-agent -s > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
}

if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" > /dev/null
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        fn_start_ssh_agent
    fi
else
    fn_start_ssh_agent
fi
