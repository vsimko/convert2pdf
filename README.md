# figconv
A useful script for scientific writing that converts multiple formats to PDF.

- converts all supported formats into PDF when modification time changes
- output PDFs are automatically cropped
- tested on **Linux** (Mint, Ubuntu, Debian, CentOS)

[![Build Status](https://travis-ci.org/vsimko/figconv.svg?branch=master)](https://travis-ci.org/vsimko/figconv)

## How to use
```sh
cd /path/to/my/latex/paper/images
figconv       # generates PDFs
figconv --png # generates PDFs and PNGs
```

## How to install - Debian derivatives
On Debian, Ubuntu and Linux Mint, you can install the [latest release as a `deb` package](https://github.com/vsimko/figconv/releases/latest). This has some optional dependencies.
After downloading the file `figconv_<VERSION>.deb`, install it using the following command:
```sh
sudo dpkg -i figconv_<VERSION>.deb
```

## How to install - Other Unix distros
You can install figconv directly from github into your `/usr/local` directory.
It is generally not recommended to run `sudo make ...` on stuff downloaded from the Internet.
**So you have been warned!**
```sh
git clone --depth 1 https://github.com/vsimko/figconv.git
cd figconv
sudo make install
```
Uninstallation also works:
```sh
sudo make uninstall
```

You can install/uninstall it somewhere else as follows:
```sh
INSTALL_PATH=/path/to/other/dir make install
INSTALL_PATH=/path/to/other/dir make uninstall
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

## Runtime Dependencies
- see [`deb-control`](deb-control) file

## How to contribute
- if you have a bug report, feature requst or just a question, use the issue tracker
- contribute code through pull requests
- pull requests must refer to some issue in the issue tracker, so add issues first

## Other links
- https://www.openhub.net/p/figconv
