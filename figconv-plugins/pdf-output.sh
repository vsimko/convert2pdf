add_output_ext pdf

function convert_pdf_to_pdf() {
  cp "$1" "$2"
}

function check_pdf() {
	cmdavail pdfseparate || {
		echo "The pdfseparate utility is not installed."
		echo "It is needed for splitting PDF files containing multiple pages."
		echo "However, if all your files contain just a single page, this script is not needed."
		echo "On Ubuntu try to install the poppler-utils package."
	}

	cmdavail pdfcrop || {
		echo "The pdfcrop utility is not installed."
		echo "This should be a small python script."
		echo "On Ubuntu try to install the texlive-extra-utils package."
		exit $CHECK_FAILED
	}
}

# Removes redundant borders from PDF files
# $1 = PDF filename
function crop_pdf_file() {
	# How many pages are inside the PDF file
	NUMPAGES=$(pdfinfo "$1" | grep ^Pages: | sed 's/[^0-9]//g')
	if [ "$NUMPAGES" -gt 1 ]
	then
		# There are 2 or more pages, we need to split the PDF
		echo -n "  Splitting PDF containing $NUMPAGES pages into separate files ... "
		pdfseparate "$1" ${1%.pdf}%d.pdf
		echo "done"
		
		# The original multi-page PDF file will not be cropped
		# All created single-page PDFs will be cropped
		LIST="${1%.pdf}?*.pdf"
	else
		# There is only 1 page, we are going to crop the original PDF
		echo "  This PDF contains only a single page - splitting not needed"
		LIST="$1"
	fi

	# now cropping PDF files from the given list
	for FILENAME in $LIST
	do
		echo -n "    Cropping PDF: $FILENAME ... "
		pdfcrop "$FILENAME" "$TMPFILE" &> /dev/null

		# removes the warning "multiple pdfs with page group included in a single page"
		#gs -q -o "$FILENAME" -dAutoRotatePages=/None -dProcessColorModel=/DeviceRGB -dNOPAUSE -dEPSCrop "$TMPFILE"

		mv "$TMPFILE" "$FILENAME"
		echo "done"
	done
	echo
}

