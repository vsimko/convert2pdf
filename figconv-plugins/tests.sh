function run_tests() {
  echo "Running some unit-tests ..."
  convert_R_to_pdf example1.R example1.pdf
  convert_dia_to_pdf example2.dia example2.pdf
  convert_odg_to_pdf example3.odg example3.pdf
  crop_pdf_file example3.pdf
  convert_svg_to_pdf example4.svg example4.pdf
  convert_pdf_to_pdf example4.pdf example5.pdf
  convert_pdf_to_png example5.pdf example5.png
  echo "all tests finished"
}

