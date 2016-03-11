# Support for PDF format.
# PDF is used as an output and also as an intermediate format.
# Therefore, this plugin is mandatory.

# registers output extension and callback for system check
add_output_ext pdf

function convert_pdf_to_pdf() {
  # copy only if the files differ
  [ "$1" -ef "$2" ] || {
    cp "$1" "$2"
  }
}

function check_pdf() {
  cmdavail pdfinfo || {
    echo "The pdfinfo utility is not installed."
    echo "Try to install the poppler-utils package."
    return 1
  }

  cmdavail pdfseparate || {
    echo "The pdfseparate utility is not installed."
    echo "It is needed for splitting PDF files containing multiple pages."
    echo "However, if all your files contain just a single page, this script is not needed."
    echo "Try to install the poppler-utils package."
    return 1

  }

  cmdavail pdfcrop || {
    echo "The pdfcrop utility is not installed."
    echo "This should be a small python script."
    echo "Try to install the texlive-extra-utils package."
    return 1
  }

}

# Removes redundant borders from PDF files.
# Parameters:
#   $1 = PDF filename
function crop_pdf_file() {

  # How many pages are inside the PDF file
  NUMPAGES=$(pdfinfo "$1" | grep ^Pages: | sed 's/[^0-9]//g')

  if [ "$NUMPAGES" -gt 1 ]
  then
    # There are 2 or more pages, we need to split the PDF
    echo -n "Splitting PDF containing $NUMPAGES pages into separate files ... "
    pdfseparate "$1" ${1%.pdf}%d.pdf
    echo "done"

    # The original multi-page PDF file will not be cropped
    # All created single-page PDFs will be cropped
    LIST="${1%.pdf}?*.pdf"
  else
    # There is only 1 page, we are going to crop the original PDF
    echo "This PDF contains only a single page - splitting not needed"
    LIST="$1"
  fi

  # now cropping PDF files from the given list
  for FILENAME in $LIST
  do
    echo -n "Cropping PDF: $FILENAME ... "
    pdfcrop "$FILENAME" "$TMPFILE" &> /dev/null

    # removes the warning "multiple pdfs with page group included in a single page"
    #gs -q -o "$FILENAME" -dAutoRotatePages=/None -dProcessColorModel=/DeviceRGB -dNOPAUSE -dEPSCrop "$TMPFILE"

    mv "$TMPFILE" "$FILENAME"
    echo "done"
  done
}

