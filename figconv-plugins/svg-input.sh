# Support for Scalable Vector Graphics (SVG) input format

add_input_ext svg

function convert_svg_to_pdf() {
  # unfortunately, SVG filters such as Duotone will be resterized
  inkscape --export-dpi=500 --export-pdf="$2" "$1" #2> /dev/null
}

function check_svg() {
  cmdavail inkscape || {
    echo "Inkscape is not installed. It is required for SVG->PDF conversion."
    echo "Try to install inkscape, e.g. sudo apt-get install inkscape."
    return 1
  }
}
