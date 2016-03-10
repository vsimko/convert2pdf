function system_check() {

  # running checks from all plugins
  get_all_extensions | while read EXT
  do
    echo -n "checking $EXT ... "
    check_$EXT
    echo "ok"
  done
}

function cmdavail() {
  type "$1" &> /dev/null
}

