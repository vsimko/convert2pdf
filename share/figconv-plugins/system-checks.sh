# running checks from all plugins
function system_check() {

  # first check if we are in the right directory
  FINDCMD="find . -maxdepth 1 -iname '' "$(get_input_extensions | sed 's/^/-or -iname *./')
  if [ $(`echo $FINDCMD` | wc -l) -lt 1 ]; then
    echoerr "This directory does not contain input images"
    exit 1
  fi

  # now check all plugins
  for EXT in `get_all_extensions`; do
    echo -n "checking $EXT ... "
    check_$EXT
    ERRCODE=$?
    if [ $ERRCODE -eq $CODE_ERROR ]; then
      echoerr "failed with return code $ERRCODE"
      exit $ERRCODE
    elif [ $ERRCODE -eq $CODE_WARNING ]; then
      echo # pass
    else
      echo "ok"
    fi
  done
}

function cmdavail() {
  type "$1" &> /dev/null
}
