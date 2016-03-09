# Evertything related to command line arguments parsing
# The application can be used without this plugin

# TODO: old implementation uses a single param to specify directory
if [ -n "$1" ]
then
	cd "$1"
else
	cd `dirname "$0"`
fi

