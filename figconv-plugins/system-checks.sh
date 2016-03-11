# running checks from all plugins
function system_check() {

  for EXT in `get_all_extensions`
  do
    echo -n "checking $EXT ... "
    check_$EXT || {
      echo "failed with return code $?"
      exit 1
    }
    echo "ok"
  done
}

function cmdavail() {
  type "$1" &> /dev/null
}
