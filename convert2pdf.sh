#!/bin/bash

# Created by Viliam Simko 2007-01-12 viliam.simko@gmail.com

# Change Log
# =========================================================
# 2015-09-03 : Viliam Simko : added support for simple R scripts
# 2014-09-16 : Viliam Simko : now the DIA files are transformed to PDF through SVG because the fonts were ugly.
# 2013-04-10 : Viliam Simko : added support for *.ods files (LibreOffice Calc Spreadsheets) + added cropping after SVG->PDF conversion
# 2013-04-03 : Viliam Simko : fixed "page group" problem (with help of gs) when including PDF files to TeX
# 2013-04-02 : Viliam Simko : added support for *.dia files
# 2012-11-01 : Viliam Simko : added support for multi-page source files converted to multiple cropped PDF files
# 2012-02-29 : Viliam Simko : added "crop" switch, which implies cropping PDF files without converting from source format
# 2011-12-23 : Viliam Simko : fixed error message if *.svg or *.odg files do not exist
# 2011-12-19 : Viliam Simko : added SVG->PDF using Inkscape
# 2011-05-05 : Viliam Simko : added system_check
# =========================================================

if [ -n "$1" ]
then
	cd "$1"
else
	cd `dirname "$0"`
fi

TMPFILE=".pdfcrop"

function cmdavail() {
	type "$1" &> /dev/null
}

function system_check() {

	cmdavail resize || {
		echo "The resize command is not installed."
		echo "However, this is not mandatory."
		echo "Try to install xterm."
	}

	cmdavail unoconv || {
		echo "The unoconv utility is not installed."
		echo "Try to install the unoconv package and libreoffice or openoffice."
	}

	{ unoconv --show; } &> /dev/null
	[ "$?" -eq 0 ] || {
		echo "WARNING: LibreOffice/OpenOffice UNO bridge (unoconv) does not work properly!"
	}

	cmdavail inkscape || {
		echo "Inkscape is not installed. It is required for SVG->PDF conversion."
		echo "Try to install inkscape, e.g. sudo apt-get install inkscape."
	}

	cmdavail pdfcrop || {
		echo "The pdfcrop utility is not installed."
		echo "This should be a small python script."
		echo "On Ubuntu try to install the texlive-extra-utils package."
		exit 1
	}

	cmdavail gs || {
		echo "Ghostscript is not installed."
		exit 1
	}

	cmdavail pdfseparate || {
		echo "The pdfseparate utility is not installed."
		echo "It is needed for splitting PDF files containing multiple pages."
		echo "However, if all your files contain just a single page, this script is not needed."
		echo "On Ubuntu try to install the poppler-utils package."
	}

	cmdavail dia || {
		echo "DIA is not installed. You won't be able to convert DIA->PDF."
		echo "Try to install DIA using: sudo apt-get install dia"
	}
}

function write_separator() {
	# prepares the separator
	eval `resize`
	echo `seq 1 $COLUMNS | sed 's/^.*//' | tr '\n' '-'`
}

# $1 = ODT NAME, $2 = PDF NAME
function convert_odt_to_pdf() {
	convert_odg_to_pdf "$1" "$2"
	crop_pdf_file "$2"
}

# $1 = ODS NAME, $2 = PDF NAME
function convert_ods_to_pdf() {
	convert_odg_to_pdf "$1" "$2"
	crop_pdf_file "$2"
}

# $1 = ODG NAME, $2 = PDF NAME
function convert_odg_to_pdf() {
	unoconv -f pdf "$1" 2> /dev/null
	echo "done."

	NEWPDFNAME="${1%.*}.pdf"
	[ "$NEWPDFNAME" != "$2" ] && mv "$NEWPDFNAME" "$2"
	crop_pdf_file "$2"
}

# $1 = SVG NAME, $2 = PDF NAME
function convert_svg_to_pdf() {
	# unfortunately, SVG filters such as Duotone will be resterized
	inkscape --export-dpi=500 --export-pdf="$2" "$1" 2> /dev/null
	crop_pdf_file "$2"
	echo "done."
}

# $1 = DIA NAME, $2 = PDF NAME
function convert_dia_to_pdf() {
	#dia -t pdf -e "$2" "$1"
	dia -t svg -e "$TMPFILE" "$1"
	convert_svg_to_pdf "$TMPFILE" "$2"
	crop_pdf_file "$2"
	echo "done."
}

# $1 = R SCRIPT, $2 = PDF NAME
function convert_R_to_pdf() {
	Rscript --vanilla - <<===
		source('$1')
		cat('R script loaded\n')
		cat(paste('Creating PDF of size', pdf.width, 'x', pdf.height, '\n'))
		pdf('$2', width=pdf.width, height=pdf.height)
		cat('Now running R code that should plot graphics to the PDF\n')
		pdf.plot()
		cat('R code done.\n')
===
	crop_pdf_file "$2"
	echo "done."
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

# $1 = mtime source
# $2 = mtime desctination
function synchronize_mtime() {
	touch -r "$1" "$2"
}

# ---------------------------- 
write_separator
# ---------------------------- 
system_check

find . -iname '*.od[gst]' \
	-or -iname '*.svg' \
	-or -name '*.dia' \
	-or -name '*.R' \
| while read INPUTNAME
do
	BASENAME="${INPUTNAME%.*}"
	SUFFIX="${INPUTNAME##*.}"
	PDFNAME="$BASENAME".pdf

	if [ "$INPUTNAME" -nt "$PDFNAME" -o "$INPUTNAME" -ot "$PDFNAME" ] # modification time differs
	then

		if [ "$1" = "crop" ]
		then

			if [ ! -f "$PDFNAME" ]
			then
				echo "PDF file not found: $PDFNAME"
				continue
			fi

			crop_pdf_file "$PDFNAME"
			# The original file and the created PDF files will have the same modification time
			synchronize_mtime "$INPUTNAME" "$PDFNAME"
			continue
		fi

		# run the conversion
		echo -n "  Converting to PDF: $INPUTNAME ... "
		convert_"$SUFFIX"_to_pdf "$INPUTNAME" "$PDFNAME"
		# The original file and the created PDF files will have the same modification time
		synchronize_mtime "$INPUTNAME" "$PDFNAME"
		continue
	fi

	echo "  No conversion needed for: $INPUTNAME"
done

# ---------------------------- 
write_separator
# ---------------------------- 

