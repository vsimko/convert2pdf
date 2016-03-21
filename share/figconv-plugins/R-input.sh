# Support for plot generated in R language

add_input_ext R

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
}

function check_R() {
  cmdavail Rscript || {
    echo "R not installed"
    return $CODE_WARNING
  }
}
