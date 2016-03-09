#!/bin/bash
# Created by Viliam Simko viliam.simko@gmail.com

INPUT_EXT=""
OUTPUT_EXT="pdf"
CHECK_FAILED=1
TMPFILE=".pdfcrop"
XS=":"
PLUGIN_DIR="figconv-plugins"

function add_input_ext() {
  EXT="$@"
  INPUT_EXT="${INPUT_EXT}${XS}${EXT// /${XS}}"
}

function add_output_ext() {
  EXT="$@"
  OUTPUT_EXT="${OUTPUT_EXT}${XS}${EXT// /${XS}}"
}

# Load all plugins
for PLUGIN in "$PLUGIN_DIR"/*.sh
do
  echo -n "Loading $PLUGIN ..."
  . "$PLUGIN"
  echo "ok"
done
echo "All plugins loaded."

write_separator
system_check
write_separator

#run_tests

exit


if [ -n "$1" ]
then
	cd "$1"
else
	cd `dirname "$0"`
fi


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

