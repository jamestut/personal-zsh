# Set SIMPLE_PROMPT=1 to disable checkmark/elapsed-time and show a plain prompt
zmodload zsh/datetime

typeset -F _start=0

preexec() { _start=$EPOCHREALTIME }

precmd() {
  _last=$?
  if (( _start > 0 )); then
    _elapsed=$(( EPOCHREALTIME - _start ))
    _start=0
  else
    _elapsed=0
  fi
  _mark=✔
  _color=green
  (( _last != 0 )) && { _mark=✘; _color=red }
  _tim=
  (( _elapsed > 3 )) && _tim=" ${_elapsed%.*}s"
}

setopt PROMPT_SUBST

# NPEI = No Extra Information in Prompt
if [[ $NEIP == 1 ]]; then
  _status_part=
  _time_part=
else
  _status_part='%F{$_color}$_mark%f'
  _time_part='%F{cyan}$_tim%f'
fi

PROMPT="${_status_part}${_time_part} %~ %# "
