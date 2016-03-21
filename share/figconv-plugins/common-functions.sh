# store the width of our terminal
NCOL=`stty size --file=/dev/stdin | cut -d" " -f2`

function write_separator() {
  echo `seq 1 $NCOL | sed 's/^.*//' | tr '\n' '-'`
}

# $1 = mtime source
# $2 = mtime desctination
function synchronize_mtime() {
  touch -r "$1" "$2"
}

function get_all_extensions() {
  echo -e "$SUPPORTED_INPUT_EXT\n$SUPPORTED_OUTPUT_EXT"
}

function get_input_extensions() {
  echo "$SUPPORTED_INPUT_EXT"
}

function get_output_extensions() {
  echo "$SUPPORTED_OUTPUT_EXT"
}

function find_all_input_files() {
  FINDCMD="find . -iname '' "$(get_input_extensions | sed 's/^/-or -iname *./')
  `echo $FINDCMD` | sort
}
