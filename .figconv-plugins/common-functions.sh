function write_separator() {
	# prepares the separator
	eval `resize`
	echo `seq 1 $COLUMNS | sed 's/^.*//' | tr '\n' '-'`
}

# $1 = mtime source
# $2 = mtime desctination
function synchronize_mtime() {
	touch -r "$1" "$2"
}

function get_all_extensions() {
  echo $(echo $INPUT_EXT $OUTPUT_EXT | tr $XS "\n" | sort -u)
}

