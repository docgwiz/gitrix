#!/bin/bash

# location: ~/.local/bin/

handle_error() {
	echo -e "\n$0 FAILED!"
	echo -e "An error occured on line ${BASH_LINENO[0]} while executing ${BASH_COMMAND}\n"
	exit 1
}

# Set a trap to call the handle_error function upon any error (ERR)
trap 'handle_error' ERR


# Check for command line argument
if [ $# -ne 1 ]; then
	echo -e "\nFAILED!\nNo file or directory specified\n"
	exit 1
fi

echo -e "\nRunning $0\n"
ls -la $1
echo -e "\n"
read -p "Are you sure you want to remove $1? (y/N) " answ

if [[ $answ == "y" || $answ == "Y" ]]; then
	rm -r $1
	echo -e "\nSuccess!"
else
	echo -e "\nAborted.\n"
	exit 1
fi

