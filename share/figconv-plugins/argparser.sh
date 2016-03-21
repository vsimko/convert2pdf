# Everything related to command line arguments parsing
# The application can be used without this plugin

while [ $# -gt 0 ]
do
  case $1 in

  -png|--png)
    OUTPUT_EXT="png"
    shift
    ;;

  -pdf|--pdf)
    OUTPUT_EXT="pdf"
    shift
    ;;

  -h|-help|--help)
    echo
    echo "USAGE: $(basename $0) [--png|--pdf|--help]"
    echo
    exit
  esac
done