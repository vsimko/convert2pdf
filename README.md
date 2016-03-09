# figconv
A useful script for scientific writing that converts multiple formats to PDF.

- converts all supported formats into PDF when modification time changes
- output PDFs are automatically cropped
- tested on **Linux** (Mint, Ubuntu, Debian, CentOS)

## How to use
- Assuming you are using LaTeX for writing your paper.
- Keep all your images in a subfolder: `mkdir images`
- Download the [convert2pdf.sh](convert2pdf.sh) script and make it executable:
  - `cd images`
  - `$ curl -o convert2pdf.sh https://raw.githubusercontent.com/vsimko/convert2pdf/master/convert2pdf.sh`
  - `chmod +x convert2pdf.sh`
- Run the script whenever needed, only modified files will be regenerated

## Supported output formats
- PDF (default and also used for intermediate conversion to other formats)
- PNG (requires Ghostscript `gs`)

## Supported input formats

- [OpenOffice]() / [LibreOffice](https://www.libreoffice.org/) formats:
  - requires `unoconv` utility
  - ODT (Writer): Every page exported as a single PDF
  - ODG (Draw): Every page exported as a single PDF
  - ODS (Calc): Every sheet exported as a single PDF

- SVG
  - requires [Inkscape](https://inkscape.org)
  - SVG filters such as Duotone will be resterized

- [Dia diagrams](http://dia-installer.de/)

- Plots generated in [R language](https://www.r-project.org/)
  - single R file per diagram
  - global parameters `pdf.width` and `pdf.heigth`

## Dependencies
- `pdfcrop`
- `pdfseparate`
- `resize`
- `unoconv`
- `inkscape`
- `dia`
- `Rscript`
- `gs`
