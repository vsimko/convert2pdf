# running checks from all plugins
function system_check() {
  for EXT in `get_all_extensions`; do
    echo -n "checking $EXT ... "
    check_$EXT
    ERRCODE=$?
    if [ $ERRCODE -eq $CODE_ERROR ]; then
      echo "ERROR: failed with return code $ERRCODE"
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
