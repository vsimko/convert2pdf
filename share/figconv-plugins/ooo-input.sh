# Support for OpenOffice / LibreOffice input formats

add_input_ext odg odt ods

function convert_odg_to_pdf() {
  echo "Running unoconv $1 -> $2"
  unoconv --verbose --format pdf "$1"

  # TODO: comment this piece of code
  NEWPDFNAME="${1%.*}.pdf"
  [ "$NEWPDFNAME" == "$2" ] || mv "$NEWPDFNAME" "$2"
}

function check_odg() {
  # is unoconv installed ?
  if cmdavail unoconv; then
    # sanity check for unoconv
    { unoconv --show; } &> /dev/null
    if [ ! "$?" -eq 0 ]; then
      echoerr "LibreOffice/OpenOffice UNO bridge (unoconv) does not work properly!"
      return $CODE_ERROR
    fi
  else
    echo "The unoconv utility is not installed."
    echo "Try to install the unoconv package and open/libreoffice."
    return $CODE_WARNING
  fi

  # Fixed issue #24 Unoconv fails when libreoffice config is missing
  soffice --headless /dev/null

  if pgrep soffice.bin; then
    echoerr "An instance of LibreOffice or OpenOffice is running."
    echoerr "This may cause unoconv tool to fail"
    read -p "Should we kill the process now [yes/no] ? (default=no): " ANS
    if [ "$ANS" == "yes" ]; then
      killall soffice.bin
    else
      return $CODE_ERROR
    fi
  fi
}

# just redirects
function convert_odt_to_pdf() {
  convert_odg_to_pdf "$@"
}
function convert_ods_to_pdf() {
  convert_odg_to_pdf "$@"
}
function check_odt() {
  check_odg
}
function check_ods() {
  check_odg
}
