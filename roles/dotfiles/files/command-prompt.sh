alias ls="ls --color -h"
alias ll="ls --color -a -h -l"
alias grep="grep --color"
eval $(dircolors) 
set show-all-if-ambiguous on
export HISTCONTROL=ignoredups
export LANG=en_US.UTF-8
set -o vi
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
last_success=0

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# default pane title is the name of the current process (i.e. 'bash')
TMUX_PANE_TITLE=$(ps -o comm $$ | tail -1)

case "$TERM" in
screen*)
  PROMPT_COMMAND="prompt_command"
  # Update title before executing a command: set it to the command
  trap 'update_title "$BASH_COMMAND"' DEBUG
  ;;
xterm*)
  PROMPT_COMMAND="prompt_command"
  ;;
*)
  ;;
esac

set_prompt() {
    Last_Command=$1 # Must come first!
    # Reset
    Color_Off='\e[0m'       # Text Reset

    # Regular Colors
    Black='\e[0;30m'        # Black
    Red='\e[0;31m'          # Red
    Green='\e[0;32m'        # Green
    Yellow='\e[0;33m'       # Yellow
    Blue='\e[0;34m'         # Blue
    Purple='\e[0;35m'       # Purple
    Cyan='\e[0;36m'         # Cyan
    White='\e[0;37m'        # White

    # Bold
    BBlack='\e[1;30m'       # Black
    BRed='\e[1;31m'         # Red
    BGreen='\e[1;32m'       # Green
    BYellow='\e[1;33m'      # Yellow
    BBlue='\e[1;34m'        # Blue
    BPurple='\e[1;35m'      # Purple
    BCyan='\e[1;36m'        # Cyan
    BWhite='\e[1;37m'       # White

    # Underline
    UBlack='\e[4;30m'       # Black
    URed='\e[4;31m'         # Red
    UGreen='\e[4;32m'       # Green
    UYellow='\e[4;33m'      # Yellow
    UBlue='\e[4;34m'        # Blue
    UBBlue='\e[1;34m'        # BoldBlue
    UPurple='\e[4;35m'      # Purple
    UCyan='\e[4;36m'        # Cyan
    UWhite='\e[4;37m'       # White

    # Background
    On_Black='\e[40m'       # Black
    On_Red='\e[41m'         # Red
    On_Green='\e[42m'       # Green
    On_Yellow='\e[43m'      # Yellow
    On_Blue='\e[44m'        # Blue
    On_Purple='\e[45m'      # Purple
    On_Cyan='\e[46m'        # Cyan
    On_White='\e[47m'       # White

    # High Intensity
    IBlack='\e[0;90m'       # Black
    IRed='\e[0;91m'         # Red
    IGreen='\e[0;92m'       # Green
    IYellow='\e[0;93m'      # Yellow
    IBlue='\e[0;94m'        # Blue
    IPurple='\e[0;95m'      # Purple
    ICyan='\e[0;96m'        # Cyan
    IWhite='\e[0;97m'       # White

    # Bold High Intensity
    BIBlack='\e[1;90m'      # Black
    BIRed='\e[1;91m'        # Red
    BIGreen='\e[1;92m'      # Green
    BIYellow='\e[1;93m'     # Yellow
    BIBlue='\e[1;94m'       # Blue
    BIPurple='\e[1;95m'     # Purple
    BICyan='\e[1;96m'       # Cyan
    BIWhite='\e[1;97m'      # White

    # High Intensity backgrounds
    On_IBlack='\e[0;100m'   # Black
    On_IRed='\e[0;101m'     # Red
    On_IGreen='\e[0;102m'   # Green
    On_IYellow='\e[0;103m'  # Yellow
    On_IBlue='\e[0;104m'    # Blue
    On_IPurple='\e[0;105m'  # Purple
    On_ICyan='\e[0;106m'    # Cyan
    On_IWhite='\e[0;107m'   # White

    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'

    # Add a bright white exit status for the last command
    #PS1="$White\$? "
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        PS1="$Green$Checkmark "
    else
        PS1="$Red$FancyX "
    fi
    PS1+="$UCyan\\D{%d.%m.%y} $UGreen\\t "
    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    if [[ $EUID == 0 ]]; then
        PS1+="$URed\\u$UBlack@\\H"
    else
        PS1+="$UBlack\\u@\\H"
    fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$UBBlue \\w/$Reset\n\\\$ "
}

update_title() {
  TITLE=$1
  set -- junk $TITLE
  printf '\033k%s\033\\' "$USER@${HOSTNAME%%.*} ${2:-$TMUX_PANE_TITLE}"
}

# user command to change default pane title on demand
function title { TMUX_PANE_TITLE="$*"; }

function prompt_command {
  current_success=$?
  if [ $last_success -eq 0 ]; then
    cmd=$(fc -nl -1)
    if [ $TERM = "screen" ]; then
      update_title
    fi
  fi
  last_success=$current_success
  if [ $current_success -eq 0 ]; then
    set_prompt 0
  else
    set_prompt 1
    if [ $TERM = "screen" ]; then
      update_title "(x) $TMUX_PANE_TITLE"
    fi
  fi
}
