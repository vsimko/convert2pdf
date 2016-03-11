#!/bin/bash

# Created by Viliam Simko viliam.simko@gmail.com
BASEDIR=`dirname $0`
PLUGIN_DIR="$BASEDIR/figconv-plugins"
TMPFILE=".pdfcrop"
OUTPUT_EXT="pdf"

function add_input_ext() {
  EXT="$@"
  SUPPORTED_INPUT_EXT=`echo ${SUPPORTED_INPUT_EXT} $EXT | tr " " "\n" | sort -u`
}

function add_output_ext() {
  EXT="$@"
  SUPPORTED_OUTPUT_EXT=`echo ${SUPPORTED_OUTPUT_EXT} $EXT | tr " " "\n" | sort -u`
}

# Load all plugins
for PLUGIN in "$PLUGIN_DIR"/*.sh
do
  echo -n "Loading $PLUGIN ... "
  . "$PLUGIN"
  echo "ok"
done
echo "All plugins loaded."

write_separator
system_check

#echo SUPPORTED INPUT EXTENSIONS: `get_input_extensions`
#echo SUPPORTED OUTPUT EXTENSIONS: `get_output_extensions`
#echo ALL EXTENSIONS: `get_all_extensions`
echo "Selected output format is: $OUTPUT_EXT"

find_all_input_files | while read INPUTNAME
do
  BASENAME="${INPUTNAME%.*}"
  SUFFIX="${INPUTNAME##*.}"
  PDFNAME="$BASENAME".pdf
  OUTNAME="$BASENAME"."$OUTPUT_EXT"

  write_separator
  if [ "$INPUTNAME" -nt "$OUTNAME" -o "$INPUTNAME" -ot "$OUTNAME" ] # modification time differs
  then

    # convert input format to output format through PDF format
    if convert_${SUFFIX}_to_pdf "$INPUTNAME" "$PDFNAME"
    then
      crop_pdf_file "$PDFNAME"
      convert_pdf_to_${OUTPUT_EXT} "$PDFNAME" "$OUTNAME"

      # The original file and the created PDF files will have the same modification time
      synchronize_mtime "$INPUTNAME" "$OUTNAME"
    else
      echo "Conversion failed."
    fi

  else
    echo "No conversion needed for: $INPUTNAME"
  fi
done
write_separator
