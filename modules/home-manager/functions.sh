function weather() {
  curl wttr.in/$1
}

function config() {
  # navigate to the config file for a specific app
  cd "$XDG_CONFIG_HOME/$1" || echo "$1 is not a valid config directory."
}

function service() {
  if [[ -z $1 ]]; then
    echo "no command provided from [stop, start, restart]"
    return 1
  fi
  if [[ -z $2 ]]; then
    echo "No service name provided"
    return 1
  fi

  service=$(launchctl list | awk "/$2/ {print $NF}")
  if [[ $1 == "restart" ]]; then
    launchctl stop $service && launchctl start $service
  else
    launchctl $1 $service
  fi
}

_dopy_completion() {
  local IFS=$'
'
  COMPREPLY=($(env COMP_WORDS="${COMP_WORDS[*]}" \
    COMP_CWORD=$COMP_CWORD \
    _DO.PY_COMPLETE=complete_bash $1))
  return 0
}

function remove_keygrips() {
  test ! "$@" && echo "Specify a key" && exit 1
  KEYGRIPS="$(gpg --with-keygrip --list-secret-keys $@ | grep Keygrip | awk '{print $3}')"
  for keygrip in $KEYGRIPS; do
    rm "$HOME"/.gnupg/private-keys-v1.d/"$keygrip".key 2>/dev/null
  done

  gpg --card-status
}

complete -o default -F _dopy_completion sysdo remove_keygrips
