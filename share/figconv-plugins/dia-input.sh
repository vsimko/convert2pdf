# Support for Dia drawings

add_input_ext dia

function convert_dia_to_pdf() {
  # old: dia -t pdf -e "$2" "$1"
  # new: transforming DIA->SVG->PDF because the fonts were ugly
  TMP=`mktemp --suffix=.svg`
  dia -t svg -e "$TMP" "$1"
  convert_svg_to_pdf "$TMP" "$2"
  rm "$TMP"
}

function check_dia() {
  cmdavail dia || {
    echo "DIA is not installed. You won't be able to convert DIA->PDF."
    echo "Try to install DIA using: sudo apt-get install dia"
    return $CODE_WARNING
  }

  cmdavail convert_svg_to_pdf || {
    echo "DIA input plugin requires SVG input plugin"
    return $CODE_WARNING
  }
}
