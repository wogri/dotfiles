if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi

NEWLINE=$'\n'
PROMPT='
%(?.%F{green}√%f.%F{red}⍉%f) %{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}@%M:%{$fg[blue]%}%B%~%b%{$reset_color%} $(git_prompt_info)%(!.#.$) '
RPROMPT='%F{green}%W %*%f'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg_no_bold[red]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="*"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exGxfxdxbxegedabagaceh"
export LS_COLORS='di=34:ln=1;36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;47'
