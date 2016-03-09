function system_check() {

	cmdavail resize || {
		echo "The resize command is not installed."
		echo "However, this is not mandatory."
		echo "Try to install xterm."
	}

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

