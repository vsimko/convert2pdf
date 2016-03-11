# figconv
A useful script for scientific writing that converts multiple formats to PDF.

- converts all supported formats into PDF when modification time changes
- output PDFs are automatically cropped
- tested on **Linux** (Mint, Ubuntu, Debian, CentOS)

[![Build Status](https://travis-ci.org/vsimko/figconv.svg?branch=master)](https://travis-ci.org/vsimko/figconv)
[![Issue Stats](http://issuestats.com/github/vsimko/figconv/badge/pr)](http://issuestats.com/github/vsimko/figconv)
[![Issue Stats](http://issuestats.com/github/vsimko/figconv/badge/issue)](http://issuestats.com/github/vsimko/figconv)

## How to use
``` sh
# assuming you keep all your files in `images` directory 
git clone -n --depth 1 https://github.com/vsimko/figconv.git images
cd images
git checkout HEAD figconv.sh
git checkout HEAD figconv-plugins
# now you can run `./figconv.sh` as needed
```

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
- see `addons:apt:packages` in file [`.travis.yml`](.travis.yml)
