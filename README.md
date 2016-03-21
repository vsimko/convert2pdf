# figconv
A useful script for scientific writing that converts multiple formats to PDF.

- converts all supported formats into PDF when modification time changes
- output PDFs are automatically cropped
- tested on **Linux** (Mint, Ubuntu, Debian, CentOS)

[![Build Status](https://travis-ci.org/vsimko/figconv.svg?branch=master)](https://travis-ci.org/vsimko/figconv)
[![Issue Stats](http://issuestats.com/github/vsimko/figconv/badge/pr)](http://issuestats.com/github/vsimko/figconv)
[![Issue Stats](http://issuestats.com/github/vsimko/figconv/badge/issue)](http://issuestats.com/github/vsimko/figconv)

## How to install
By default, the tool will be installed to `/usr/local`
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

## How to use
```sh
cd /path/to/my/latex/paper/images
figconv       # generates PDFs
figconv --png # generates PDFs and PNGs
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

## How to contribute
- if you have a bug report, feature requst or just a question, use the issue tracker
- contribute code through pull requests
- pull requests must refer to some issue in the issue tracker, so add issues first

## Other links
- https://www.openhub.net/p/figconv

## Testing in a virtual machine
Using [vagrant](https://www.vagrantup.com/) + [virtualbox](https://www.virtualbox.org/)
```sh
# we need some virtualization backend, here we use virtualbox
sudo apt-get install virtualbox

# install latest vagrant (1.8+ older versions may not work properly)
https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
dpkg -i vagrant_1.8.1_x86_64.deb

# the VM will live in this directory
mkdir figconv-vm
cd figconv-vm

# now initialize Ubuntu 12.04 LTS (precise)
# same as Travis-CI uses for automated builds
vagrant init hashicorp/precise64
vagrant up
vagrant ssh
```

Now, you should be logged into the VM running Ubuntu.
```sh
# install git and make first
sudo apt-get install git
sudo apt-get install make

# install mandatory dependencies for figconv
sudo apt-get install poppler-utils
sudo apt-get install texlive-extra-utils

# install optional dependencies for figconv
sudo apt-get install dia                  # diagrams made in dia
sudo apt-get install inkscape             # SVG
sudo apt-get install unoconv libreoffice  # Open/LibreOffice formats
sudo apt-get install r-base-core          # when using R

# now install figconv
git clone --depth 1 https://github.com/vsimko/figconv.git
cd figconv
sudo make install
```

Sample files in `tests/` can now be converted.
```sh
figconv

# this lists all generated PDF files
ls tests/*.pdf

# copy the generated files from guest vm to host system
cp -r tests /vagrant
exit # now exit the guest vm

ls -l # list the files in your host system
```
