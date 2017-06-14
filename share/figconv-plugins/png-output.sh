# Support for PNG output format

add_output_ext png

function convert_pdf_to_png() {
  PDFFILE="$1"
  PNGFILE="$2"
  echo "Converting PDF=$PDFFILE to PNG=$PNGFILE ..."
#  convert -density 150 "$PDFFILE" -quality 90 "$PNGFILE"
#  inkscape "$PDFFILE" -z --export-dpi=300 --export-area-drawing --export-png="$PNGFILE"
  gs -sDEVICE=png16m -dTextAlphaBits=4 -r300 -o "$PNGFILE" "$PDFFILE"
}

function check_png() {
  cmdavail gs || {
    echoerr "Ghostscript not installed (gs command)"
    return $CODE_WARNING
  }
}

