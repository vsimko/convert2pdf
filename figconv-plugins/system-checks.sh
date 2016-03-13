# running checks from all plugins
function system_check() {

  for EXT in `get_all_extensions`; do
    echo -n "checking $EXT ... "
    if ! check_$EXT; then
      echo "failed with return code $?"
      exit 1
    fi
    echo "ok"
  done
}

function cmdavail() {
  type "$1" &> /dev/null
}
