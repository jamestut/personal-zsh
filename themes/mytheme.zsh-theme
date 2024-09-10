autoload -U add-zsh-hook

function prompt_char {
    if [[ $(id -u) -eq 0 ]]
    then
      echo -n '%B%F{red}#%f%b'
    else
      echo -n '%B%F{blue}$%f%b'
    fi
}

function prompt_err {
    if (($MYTHEME_HIDE[(Ie)error]))
    then
        return
    fi
    if [[ $MYTHEME_EC -ne 0 ]]
    then
      echo -n "%K{red} ✗ $MYTHEME_EC "
    fi
}

function preexec_duration {
    MYTHEME_TIME_PREEXEC=$(date +'%s')
}

function my_precmd {
    # for recording return number
    MYTHEME_EC=$?
    # for recording duration
    if [[ $MYTHEME_TIME_PREEXEC -ne 0 ]]
    then
        (( MYTHEME_DURATION = $(date +'%s') - $MYTHEME_TIME_PREEXEC ))
        MYTHEME_TIME_PREEXEC=0
    else
        MYTHEME_DURATION=0
    fi
}

function prompt_duration {
    if (($MYTHEME_HIDE[(Ie)duration]))
    then
        return
    fi
    if ! (($MYTHEME_HIDE[(Ie)emoji]))
    then
        ICON='⏳ '
    fi
    if [[ $MYTHEME_DURATION -gt 1 ]]
    then
        echo -n "%K{5}$ICON${MYTHEME_DURATION}s "
    fi
}

function prompt_time {
    if (($MYTHEME_HIDE[(Ie)time]))
    then
        return
    fi
    if ! (($MYTHEME_HIDE[(Ie)emoji]))
    then
        ICON=' ⏰'
    fi
    echo -n "%F{6} %T$ICON"
}

function prompt_dir {
    if (($MYTHEME_HIDE[(Ie)dir]))
    then
        return
    fi
    if ! (($MYTHEME_HIDE[(Ie)emoji]))
    then
        ICON='📁 '
    fi
    echo -n "%K{blue}$ICON%~ "
}

function prompt_computer_name {
    if (($MYTHEME_HIDE[(Ie)computer]))
    then
        return
    fi
    if ! (($MYTHEME_HIDE[(Ie)emoji]))
    then
        ICON='🏠 '
    fi
    echo -n "%K{green}$ICON%n@%m "
}

# adjust keyboard shortcuts
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

setopt PROMPT_SUBST
add-zsh-hook preexec preexec_duration
add-zsh-hook precmd my_precmd
MYTHEME_TIME_PREEXEC=0

PROMPT='%F{231}$(prompt_computer_name)$(prompt_dir)$(prompt_err)$(prompt_duration)%k $(prompt_char) '
# RPROMPT='$(prompt_time)'
