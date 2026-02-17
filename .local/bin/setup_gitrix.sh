#!/bin/bash

# location: ~/.local/bin/<filename>

# -------------------
# REFRESH GITRIX REPO

REPO_LOC="$HOME"
REPO_FNAME="gitrix"
REPO_DIR="$REPO_LOC/$REPO_FNAME"

echo -e "\n\nSetting up the $REPO_FNAME repo ..."
if [[ -d "$REPO_DIR" ]]; then
	echo -e "\n$REPO_FNAME repo exists at $REPO_DIR."
	echo -e "\nPulling from GitHub to update ...\n"
	if confirm_go; then
		cd $REPO_DIR
		git pull origin main
	else
		echo -e "Script file terminated.\n"
		exit 0
	fi
else 
	echo -e "\nCloning the $REPO_FNAME repo from GitHub ...\n" 
	if confirm_go; then
		cd $REPO_LOC
		git clone https://github.com/docgwiz/gitrix.git
	else
		echo -e "Script file terminated.\n"
		exit 0
	fi
fi

