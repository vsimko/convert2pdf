function system_check() {

	cmdavail resize || {
		echo "The resize command is not installed."
		echo "However, this is not mandatory."
		echo "Try to install xterm."
	}

  # running checks from all plugins
  for EXT in `get_all_extensions`
  do
    echo -n "checking $EXT ... "
    check_$EXT
    echo "ok"
  done
}

function cmdavail() {
	type "$1" &> /dev/null
}

